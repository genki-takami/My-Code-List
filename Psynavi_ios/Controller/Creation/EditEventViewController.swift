/*
 編集オブジェクトのイベントの編集処理
 */

import UIKit
import RealmSwift
import SVProgressHUD
import Firebase

final class EditEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DataReturn {
    
    // 変数
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventContent: UITextView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var eventDate: UITextField!
    var selectedImage: UIImage!
    var selectedCaption: String!
    let realm = try! Realm()
    var event: EventsDB!

    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !self.event.eventTitle.isEmpty{
            // 編集のセットアップ
            self.eventName.text = self.event.eventTitle
            self.eventContent.text = self.event.caption
            self.eventDate.text = self.event.eventDate
        }
        
        // デリゲート・データソース
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
        // コレクションビューにロングタップを追加
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressAction))
        self.imageCollection.addGestureRecognizer(longPressRecognizer)
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // コレクションを削除する
    @objc func onLongPressAction(sender: UILongPressGestureRecognizer) {
        let point: CGPoint = sender.location(in: self.imageCollection)
        let indexPath = self.imageCollection.indexPathForItem(at: point)
        if let indexPath = indexPath {
            let message = "ロングタップした画像とそのキャプションを削除しますか？"
            let alertController: UIAlertController = UIAlertController(title: "画像を削除", message: message, preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "削除", style: .default){ action in
                // 削除する
                self.event.images.remove(at: indexPath.row)
                self.event.imageCaptions.remove(at: indexPath.row)
                SVProgressHUD.showSuccess(withStatus: "削除完了！")
                self.imageCollection.reloadData()// コレクションをリロード
            }
            let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alertController.addAction(actionYes)
            alertController.addAction(actionCancel)
            self.present(alertController, animated: true, completion: nil)
        }
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
    
    // ライブラリを指定してピッカーを開く
    @IBAction func selectImages(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.modalPresentationStyle = .fullScreen
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // 選択した画像をもとに、キャプション設定画面に遷移
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let info = info[.originalImage] {
            let eventImageCreateViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventImageCreate") as! EditEventImageViewController
            eventImageCreateViewController.image = info as? UIImage
            eventImageCreateViewController.delegate = self
            picker.present(eventImageCreateViewController, animated: true, completion: nil)
        }
    }
    
    // 受け取ったデータをデータベースに保存
    func returnData(imageData: UIImage, captionData: String){
        self.event.images.append(imageData.jpegData(compressionQuality: 0.75)!)
        self.event.imageCaptions.append(captionData)
        imageCollection.reloadData()// コレクションをリロード
    }

    // ピッカーをキャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // イベントを保存
    @IBAction func save(_ sender: Any) {
        if let name = eventName.text, let content = eventContent.text, let date = eventDate.text{
            
            if name.isEmpty || content.isEmpty || date.isEmpty{
                SVProgressHUD.showError(withStatus: "タイトル/内容/日時を記入してください！")
                return
            }
            
            SVProgressHUD.show()
            
            do {
                try realm.write {
                    self.event.eventTitle = name
                    self.event.caption = content
                    self.event.eventDate = date
                    self.realm.add(self.event, update: .modified)
                }
            } catch _ as NSError {
                Analytics.logEvent("error_EventsEditViewController_save", parameters: [AnalyticsParameterItemName:"イベントの作成・編集に失敗" as String])
                SVProgressHUD.showError(withStatus: "\(name)の作成・編集に失敗")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            SVProgressHUD.showSuccess(withStatus: "保存しました！")
        }
    }
    
    // セルの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return event.images.count
    }
    
    // セルの中身を返す
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        let imageView = imageCell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(data:event.images[indexPath.row])
        
        // タップを検知
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        imageCell.addGestureRecognizer(tapGesture)
        
        return imageCell
    }
    
    // セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer){
        collectionView(self.imageCollection, didSelectItemAt: sender.indexValue!)
    }
    
    // セルのタップ時の処理を返す
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // イベント画像とキャプションを渡して画面遷移
        selectedImage = UIImage(data:event.images[indexPath.row])
        selectedCaption = event.imageCaptions[indexPath.row]
        if selectedImage != nil || selectedCaption != nil{
            performSegue(withIdentifier: "toImageShowCell",sender: nil)
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toImageShowCell" {
            let eventImageShowViewController:EditEventImagePreviewController = segue.destination as! EditEventImagePreviewController
            eventImageShowViewController.selectedImage = selectedImage
            eventImageShowViewController.selectedCaption = selectedCaption
        }
    }
    
    // セルのサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // １行３セル
        let cellSize:CGFloat = self.view.frame.width / 3
 
        // 正方形で返す
        return CGSize(width: cellSize, height: cellSize)
    }
}
