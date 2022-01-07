/*
 新規作成・編集の処理
 */

import UIKit
import RealmSwift
import SVProgressHUD
import Accounts

class InputViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // 変数
    @IBOutlet weak var injured: UITextField!
    @IBOutlet weak var reporter: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var spot: UITextField!
    @IBOutlet weak var part: UITextField!
    @IBOutlet weak var diagnosis: UITextField!
    @IBOutlet weak var cause: UITextField!
    @IBOutlet weak var aftereffect: UITextField!
    @IBOutlet weak var picture: UIImageView!
    var reportData: Database!
    let realm = try! Realm()
    var didSaving = false
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        injured.text = reportData.injured
        reporter.text = reportData.reporter
        date.date = reportData.date
        spot.text = reportData.spot
        part.text = reportData.part
        diagnosis.text = reportData.diagnosis
        cause.text = reportData.cause
        aftereffect.text = reportData.aftereffect
        NSData(data: reportData.image).count != 0 ? (picture.image = UIImage(data: reportData.image)) : (picture.image = UIImage(systemName: "questionmark.square.dashed"))
        
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // カメラを起動して画像を撮影する
    @IBAction func setImageByCamera(_ sender: Any) {
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // ライブラリを起動して画像を選択する
    @IBAction func setImageFromLibrary(_ sender: Any) {
        // ライブラリを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // 写真を撮影・選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let info = info[.originalImage]{
            // 撮影・選択された画像を取得する
            self.picture.image = info as? UIImage
            self.dismiss(animated: true, completion: nil)
        }
    }

    // ピッカーのキャンセルボタンが押された時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存
    @IBAction func save(_ sender: Any) {
        if let injured = self.injured.text, let reporter = self.reporter.text{
            
            if injured.isEmpty || reporter.isEmpty{
                SVProgressHUD.showError(withStatus: "負傷者と報告者を記入してください")
                return
            }
            
            SVProgressHUD.show()
            
            do {
                try realm.write{
                    self.reportData.injured = injured
                    self.reportData.reporter = reporter
                    self.reportData.date = date.date
                    self.reportData.spot = spot.text!
                    self.reportData.part = part.text!
                    self.reportData.diagnosis = diagnosis.text!
                    self.reportData.cause = cause.text!
                    self.reportData.aftereffect = aftereffect.text!
                    if let data = picture.image?.jpegData(compressionQuality: 0.75), NSData(data: data).count != 0{
                        self.reportData.image = data
                    }
                    self.realm.add(self.reportData, update: .modified)
                }
                self.didSaving = true
                SVProgressHUD.showSuccess(withStatus: "保存作業が完了！")
            } catch _ as NSError {
                SVProgressHUD.showError(withStatus: "保存に失敗！")
                self.didSaving = false
            }
        }
    }
    
    // 共有
    @IBAction func share(_ sender: Any) {
        self.save(true)
        
        if didSaving{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString:String = formatter.string(from: self.reportData.date)
            let p1 = "【負傷者】\n\(self.reportData.injured)\n\n"
            let p2 = "【報告者】\n\(self.reportData.reporter)\n\n"
            let p3 = "【発生日時】\n\(dateString)\n\n"
            let p4 = "【場所】\n\(self.reportData.spot)\n\n"
            let p5 = "【負傷部位】\n\(self.reportData.part)\n\n"
            let p6 = "【医師による診断名】\n\(self.reportData.diagnosis)\n\n"
            let p7 = "【主な原因】\n\(self.reportData.cause)\n\n"
            let p8 = "【後遺症など】\n\(self.reportData.aftereffect)\n\n"
            let connectedText = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8
            
            let shareText = connectedText
            let activityItems = [shareText]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            let excludedActivityTypes = [
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.message,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.markupAsPDF
            ]
            activityVC.excludedActivityTypes = excludedActivityTypes
            // UIActivityViewControllerを表示
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    // PDFの作成
    @IBAction func createPDF(_ sender: Any) {
        self.save(true)
        
        if didSaving{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString:String = formatter.string(from: self.reportData.date)
            let p0 = "　　　　　　　　ケガに関するレポート powerd by 外傷レポートapp\n\n"
            let p1 = "【負傷者】\n\(self.reportData.injured)\n\n"
            let p2 = "【報告者】\n\(self.reportData.reporter)\n\n"
            let p3 = "【発生日時】\n\(dateString)\n\n"
            let p4 = "【場所】\n\(self.reportData.spot)\n\n"
            let p5 = "【負傷部位】\n\(self.reportData.part)\n\n"
            let p6 = "【医師による診断名】\n\(self.reportData.diagnosis)\n\n"
            let p7 = "【主な原因】\n\(self.reportData.cause)\n\n"
            let p8 = "【後遺症など】\n\(self.reportData.aftereffect)\n\n"
            let connectedText = p0 + p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8
            
            let pdfViewerViewController = PDFViewerViewController()
            pdfViewerViewController.reportText = connectedText
            if let data = picture.image{
                pdfViewerViewController.image = data
            }
            let navigationViewController = UINavigationController(rootViewController: pdfViewerViewController)
            self.present(navigationViewController, animated: true, completion: nil)
        }
    }
}
