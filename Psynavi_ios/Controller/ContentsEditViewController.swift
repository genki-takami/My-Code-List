/*
 編集オブジェクトのコンテンツの編集処理
 */

import UIKit
import RealmSwift
import SVProgressHUD
import Firebase

class ContentsEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 変数
    @IBOutlet weak var shopOrDisplaySwitch: UISwitch!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var managerName: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var tag: UITextField!
    @IBOutlet weak var infoText: UITextView!
    @IBOutlet weak var managerInfo: UITextView!
    var isShop = true
    var content: ContentsDB!
    let realm = try! Realm()

    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !content.name.isEmpty{
            // 編集セットアップ
            self.shopOrDisplaySwitch.isOn = self.content.switchFlag
            self.isShop = self.content.switchFlag
            self.name.text = self.content.name
            self.managerName.text = self.content.manager
            self.date.text = self.content.date
            self.place.text = self.content.place
            self.selectedImage.image = UIImage(data: self.content.image)
            self.tag.text = self.content.tag
            self.infoText.text = self.content.info
            self.managerInfo.text = self.content.managerInfo
        }
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 遷移元のライフサイクルメソッドを維持する
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
        }
        super.viewWillAppear(animated)
    }
    
    // 遷移元のライフサイクルメソッドを維持する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    // 遷移元のライフサイクルメソッドを維持する
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    // ピッカーを開く
    @IBAction func selectImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.modalPresentationStyle = .fullScreen
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // 写真を選択
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let info = info[.originalImage] {
            // 選択された画像を表示して、ピッカーを閉じる
            self.selectedImage.image = info as? UIImage
            self.dismiss(animated: true, completion: nil)
        }
    }

    // ピッカーのキャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ショップか展示かを切り替える
    @IBAction func changeSwitch(_ sender: UISwitch) {
        if sender.isOn{
            self.isShop = true
            self.shopOrDisplaySwitch.isOn = true
        } else {
            self.isShop = false
            self.shopOrDisplaySwitch.isOn = false
        }
    }
    
    // コンテンツを保存
    @IBAction func save(_ sender: Any) {
        if let nameOne = name.text, let manager = managerName.text{
            
            if nameOne.isEmpty || manager.isEmpty{
                SVProgressHUD.showError(withStatus: "ショップ名/展示名および運営団体名を記入して下さい！")
                return
            }
            
            if NSData(data: (self.selectedImage.image?.jpegData(compressionQuality: 0.75))!).count == 0{
                SVProgressHUD.showError(withStatus: "画像を選択してください")
                return
            }
            
            SVProgressHUD.show()
            
            do {
                try realm.write{
                    self.content.name = nameOne
                    self.content.switchFlag = self.isShop
                    self.content.manager = manager
                    self.content.date = self.initializingText(self.date.text!)
                    self.content.place = self.initializingText(self.place.text!)
                    self.content.image = (self.selectedImage.image?.jpegData(compressionQuality: 0.75)!)!
                    self.content.tag = self.initializingText(self.tag.text!)
                    self.content.info = self.initializingText(self.infoText.text)
                    self.content.managerInfo = self.initializingText(self.managerInfo.text)
                    self.realm.add(self.content, update: .modified)
                }
            } catch _ as NSError {
                Analytics.logEvent("error_ContentsEditViewController_save", parameters: [AnalyticsParameterItemName:"コンテンツの作成・編集に失敗" as String])
                SVProgressHUD.showError(withStatus: "\(nameOne)の保存に失敗しました")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            SVProgressHUD.showSuccess(withStatus: "保存しました！")
        }
    }
    
    func initializingText(_ text: String) -> String {
        if text.isEmpty {
            return "----"
        } else {
            return text
        }
    }
}
