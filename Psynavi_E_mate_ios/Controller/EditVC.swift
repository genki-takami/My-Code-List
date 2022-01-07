/*
 編集画面
 */

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD
import AVKit

protocol DataReturn {
    func returnData(imageData: UIImage, captionData: String)
}

class EditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DataReturn {

    // 変数
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventContent: UITextView!
    @IBOutlet weak var eventCollection: UICollectionView!
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var addVideoBtn: UILabel!
    var dic: [String:Any]!
    var imageCaptions: [String] = []
    var temporaryFileURL: NSURL! = nil
    var selectedImage: UIImage!
    var selectedCaption: String!
    let ref = Storage.storage().reference()
    var refArray: [Any] = []
    var deleteArray: [StorageReference] = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート・データソース
        eventCollection.delegate = self
        eventCollection.dataSource = self
        
        // テキストデータ
        eventTitle.text = dic["eventTitle"] as? String
        eventContent.text = dic["caption"] as? String
        eventDate.text = dic["eventDate"] as? String
        self.imageCaptions = dic["imageCaptions"] as! [String]
        // 画像データ
        if !self.imageCaptions.isEmpty{
            for i in self.imageCaptions{
                // StorageReference を格納していく
                self.refArray.append(
                    self.ref.child(dic["uid"] as! String)
                        .child("event-image")
                        .child(dic["eventTitle"] as! String)
                        .child(i.prefix(10) + ".jpg")
                )
            }
        }

        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
        // コレクションビューにロングタップを追加
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressAction))
        self.eventCollection.addGestureRecognizer(longPressRecognizer)
    }
            
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // コレクションを削除する
    @objc func onLongPressAction(sender: UILongPressGestureRecognizer) {
        let point: CGPoint = sender.location(in: self.eventCollection)
        let indexPath = self.eventCollection.indexPathForItem(at: point)
        if let indexPath = indexPath {
            let message = "ロングタップした画像とそのキャプションを削除しますか？"
            let alertController: UIAlertController = UIAlertController(title: "画像を削除", message: message, preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "削除", style: .default){ action in
                if self.refArray[indexPath.row] is StorageReference {
                    // 削除リストに追加
                    let path: StorageReference = self.refArray[indexPath.row] as! StorageReference
                    self.deleteArray.append(path)
                }
                self.refArray.remove(at: indexPath.row)
                self.imageCaptions.remove(at: indexPath.row)
                self.eventCollection.reloadData()
            }
            let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alertController.addAction(actionYes)
            alertController.addAction(actionCancel)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let key = (dic["id"] as! String) + "-video"
        if dic["upgrade"] as! Bool || UserDefaults.standard.bool(forKey: key){
            self.addVideoBtn.text = "動画を変更"
        }
        eventCollection.reloadData()
    }
    
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return refArray.count
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionEditCell", for: indexPath)
        
        let imageView = imageCell.contentView.viewWithTag(1) as! UIImageView
        // 画像データ
        if refArray[indexPath.row] is StorageReference{
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_setImage(with: refArray[indexPath.row] as! StorageReference)
        } else if refArray[indexPath.row] is UIImage{
            imageView.image = refArray[indexPath.row] as? UIImage
        }
        
        // セルのタップ検知
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        imageCell.addGestureRecognizer(tapGesture)
        
        return imageCell
    }
    
    // セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer){
        collectionView(self.eventCollection, didSelectItemAt: sender.indexValue!)
    }
    
    // セルが選択された時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // UIImageとキャプションを持って画面遷移
        if self.refArray[indexPath.row] is StorageReference{
            self.selectedImage = (collectionView.cellForItem(at: indexPath)?.contentView.viewWithTag(1) as! UIImageView).image
        } else if self.refArray[indexPath.row] is UIImage{
            self.selectedImage = self.refArray[indexPath.row] as? UIImage
        }
        selectedCaption = self.imageCaptions[indexPath.row]
        if selectedImage != nil || selectedCaption != nil{
            performSegue(withIdentifier: "fromEditToImageshowSegue",sender: nil)
        }
    }
    
    // セルのサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // １行３セル
        let cellSize:CGFloat = self.view.frame.width / 3
        // 正方形で返す
        return CGSize(width: cellSize, height: cellSize)
    }
    
    // データを受け取る
    func returnData(imageData: UIImage, captionData: String){
        self.refArray.append(imageData)
        self.imageCaptions.append(captionData)
        eventCollection.reloadData()
    }
    
    // 画像をフォトライブラリから選択する
    @IBAction func selectImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.modalPresentationStyle = .fullScreen
            pickerController.sourceType = .photoLibrary
            pickerController.title = "image"
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // 写真か動画を選択
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        switch picker.title {
        case "image":
            if let info = info[.originalImage] {
                let captionEditVC = self.storyboard?.instantiateViewController(withIdentifier: "CaptionEdit") as! CaptionEditVC
                captionEditVC.image = info as? UIImage
                captionEditVC.delegate = self
                picker.present(captionEditVC, animated: true, completion: nil)
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
    
    // 動画を選択する
    @IBAction func selectVideo(_ sender: Any) {
        let key = (dic["id"] as! String) + "-video"
        if dic["upgrade"] as! Bool || UserDefaults.standard.bool(forKey: key){
            // 課金済み
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                pickerController.title = "video"
                pickerController.modalPresentationStyle = .fullScreen
                pickerController.mediaTypes = ["public.movie"]
                pickerController.allowsEditing = true
                pickerController.videoQuality = .typeLow
                self.present(pickerController, animated: true, completion: nil)
            }
        } else {
            // 未課金
            let billingVC = self.storyboard?.instantiateViewController(withIdentifier: "billingSheet") as! BillingVC
            billingVC.id = (dic["id"] as! String) + "-video"
            billingVC.modalPresentationStyle = .automatic
            self.present(billingVC, animated: true, completion: nil)
        }
    }
    
    // 確認画面へいく
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
            previewVC.et = eventTitle.text
            previewVC.ed = eventDate.text
            previewVC.ec = eventContent.text
            previewVC.video = dic["video"] as? Bool
            previewVC.url = self.temporaryFileURL
            previewVC.refArray = self.refArray
            previewVC.imageCaptions = self.imageCaptions
            previewVC.deleteArray = self.deleteArray
        case "fromEditToImageshowSegue":
            let eventImageShowVC: EventImageShowVC = segue.destination as! EventImageShowVC
            eventImageShowVC.image = self.selectedImage
            eventImageShowVC.caption = self.selectedCaption
        default:
            break
        }
    }
    
    // 認証画面に戻る
    @IBAction func backToCertificate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
