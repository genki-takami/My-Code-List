/*
 編集画面
 */

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD
import AVKit

class EditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 変数
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var manager: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var tag: UITextField!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var managerInfo: UITextView!
    @IBOutlet weak var videoBtn: UILabel!
    var dic: [String:Any]!
    var temporaryFileURL: NSURL! = nil
    var newImage = false
    let ref = Storage.storage().reference()
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // テキストデータ
        contentTitle.text = dic["name"] as? String
        manager.text = dic["manager"] as? String
        date.text = dic["date"] as? String
        place.text = dic["place"] as? String
        tag.text = dic["tag"] as? String
        info.text = dic["info"] as? String
        managerInfo.text = dic["managerInfo"] as? String
        // 画像データ
        contentImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let fileName = (dic["name"] as! String) + ".jpg"
        contentImage.sd_setImage(with: ref.child(dic["uid"] as! String).child("content-image").child(fileName))
        
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let key = (dic["id"] as! String) + "-video"
        if dic["upgrade"] as! Bool || UserDefaults.standard.bool(forKey: key){
            self.videoBtn.text = "動画を変更"
        }
    }
    
    // 画像を選択
    @IBAction func selectImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            pickerController.title = "image"
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // 写真を選択
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        switch picker.title {
        case "image":
            if let info = info[.originalImage] {
                // 選択された画像を表示
                self.contentImage.image = info as? UIImage
                self.newImage = true
                self.dismiss(animated: true, completion: nil)
            }
        case "video":
            if let info = info[.mediaURL] as? NSURL{
                let video = AVURLAsset(url: info as URL)
                let durationTime = TimeInterval(round(Float(video.duration.value) / Float(video.duration.timescale)))
                let min = Int(durationTime / 60)
                let sec = Int(round(durationTime.truncatingRemainder(dividingBy: 60)))
                if min < 1 && sec < 16{
                    SVProgressHUD.show()
                    // 拡張子を調整
                    let fileType = String(info.absoluteString!.lowercased().suffix(3))
                    if fileType == "mp4" || fileType == "m4v"{
                        // 一時フォルダを作成
                        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                        // 一時ファイルを作成
                        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent("rendered-video.mp4")
                        // コピーする
                        do {
                            try FileManager().copyItem(at: info.absoluteURL!, to: temporaryFileURL)
                            self.temporaryFileURL = temporaryFileURL as NSURL
                            SVProgressHUD.showSuccess(withStatus: "動画を設定しました")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                self.dismiss(animated: true, completion: nil)
                            }
                        } catch {
                            // There was an error copying the video file to the temporary location.
                            SVProgressHUD.showError(withStatus: "エラーが発生！再度試して下さい")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } else if fileType == "mov" {
                        // エンコードする
                        self.encodeVideo(at: info) { url, err in
                            if let _ = err{
                                SVProgressHUD.showError(withStatus: "エラーが発生！再度試して下さい")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                    self.dismiss(animated: true, completion: nil)
                                }
                            } else {
                                if let url = url{
                                    self.temporaryFileURL = url
                                    SVProgressHUD.showSuccess(withStatus: "動画を設定しました")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                } else {
                                    SVProgressHUD.showError(withStatus: "処理が中断されました")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    } else {
                        SVProgressHUD.showError(withStatus: "データタイプが不正です")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "動画の長さを15秒以内にして下さい")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        default:
            break
        }
    }

    // ピッカーのキャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 処理：mov to mp4
    func encodeVideo(at videoURL: NSURL, completionHandler: ((NSURL?, Error?) -> Void)?)  {
        let avAsset = AVURLAsset(url: videoURL as URL, options: nil)
                        
        // エクスポートセッションを作成
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
            completionHandler?(nil, nil)
            return
        }
            
        // 一時フォルダを作成
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        // 一時ファイルを作成
        let filePath = temporaryDirectoryURL.appendingPathComponent("rendered-video.mp4")
            
        // 既存のファイルを削除
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch let error {
                completionHandler?(nil, error)
            }
        }
        
        exportSession.outputURL = filePath
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.timeRange = CMTimeRangeMake(start: CMTimeMakeWithSeconds(0.0, preferredTimescale: 0), duration: avAsset.duration)
            
        exportSession.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession.status {
            case .failed:
                completionHandler?(nil, exportSession.error)
            case .cancelled:
                completionHandler?(nil, nil)
            case .completed:
                completionHandler?(exportSession.outputURL as NSURL?, nil)
            default:
                break
            }
        })
    }
    
    // 動画を追加
    @IBAction func selectVideo(_ sender: Any) {
        let key = (dic["id"] as! String) + "-video"
        if dic["upgrade"] as! Bool || UserDefaults.standard.bool(forKey: key){
            // 課金済み
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                pickerController.title = "video"
                pickerController.mediaTypes = ["public.movie"]
                pickerController.allowsEditing = true
                pickerController.videoQuality = .typeLow
                self.present(pickerController, animated: true, completion: nil)
            }
        } else {
            // 未課金
            performSegue(withIdentifier: "billSegue", sender: nil)
        }
    }
    
    //確認画面へいく
    @IBAction func goPreview(_ sender: Any) {
        performSegue(withIdentifier: "previewSegue", sender: nil)
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "previewSegue":
            let previewVC: PreviewVC = segue.destination as! PreviewVC
            previewVC.uid = dic["uid"] as? String
            previewVC.id = dic["id"] as? String
            previewVC.upgrade = dic["upgrade"] as? Bool
            previewVC.name = dic["name"] as? String
            previewVC.tag = tag.text
            previewVC.manager = manager.text
            previewVC.date = date.text
            previewVC.place = place.text
            previewVC.info = info.text
            previewVC.managerInfo = managerInfo.text
            previewVC.url = temporaryFileURL
            previewVC.video = dic["video"] as? Bool
            previewVC.image = self.contentImage.image
            previewVC.newImage = self.newImage
        case "billSegue":
            let billingVC: BillingVC = segue.destination as! BillingVC
            billingVC.id = (dic["id"] as! String) + "-video"
        default:
            break
        }
    }
    
    // 認証画面に戻る
    @IBAction func backToCertificate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
