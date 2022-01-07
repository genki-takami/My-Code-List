/*
 確認画面
 */

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD
import AVFoundation
import AVKit

class PreviewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 変数
    @IBOutlet weak var eventCollection: UICollectionView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventContent: UITextView!
    var uid, id, et, ed, ec: String!
    var upgrade, video: Bool!
    var url: NSURL!
    let ref = Storage.storage().reference()
    var refArray: [Any] = []
    var selectedImage: UIImage!
    var selectedCaption: String!
    var imageCaptions: [String] = []
    var deleteArray: [StorageReference] = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート・データソース
        eventCollection.delegate = self
        eventCollection.dataSource = self
        
        eventTitle.text = et
        eventDate.text = ed
        eventContent.text = ec
    }
    
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return refArray.count
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionPreviewCell", for: indexPath)
        
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
            performSegue(withIdentifier: "fromPreviewToImageshowSegue",sender: nil)
        }
    }
    
    // セルのサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // １行３セル
        let cellSize:CGFloat = self.view.frame.width / 3
        // 正方形で返す
        return CGSize(width: cellSize, height: cellSize)
    }
    
    // 再生準備
    @IBAction func playVideo(_ sender: Any) {
        let key = id + "-video"
        if upgrade || UserDefaults.standard.bool(forKey: key){
            // 課金済み
            if let url = self.url{
                // 端末から動画を参照
                self.playing(url)
            } else {
                // クラウドストレージから参照
                if self.video{
                    // アップロード済み
                    let fileName = self.et + ".mp4"
                    let videoRef = self.ref.child(self.uid).child("event-video").child(fileName)
                    videoRef.downloadURL { u, err in
                        if let _ = err{
                            SVProgressHUD.showError(withStatus: "エラーが発生しました")
                        } else {
                            self.playing(u! as NSURL)
                            SVProgressHUD.show(withStatus: "ストリーミング中")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                } else {
                    // アップグレードしたが動画はまだ投稿していない
                    SVProgressHUD.showInfo(withStatus: "動画は投稿されていません")
                }
            }
        } else {
            // 無課金
            SVProgressHUD.showInfo(withStatus: "動画は投稿されていません")
        }
    }
    
    // 動画を再生
    func playing(_ url: NSURL){
        let player = AVPlayer(url: url as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromPreviewToImageshowSegue"{
            let eventImageShowVC: EventImageShowVC = segue.destination as! EventImageShowVC
            eventImageShowVC.image = self.selectedImage
            eventImageShowVC.caption = self.selectedCaption
        }
    }
    
    // 編集画面へ戻る
    @IBAction func backToEdit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存する
    @IBAction func save(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "アップロード中...")
        // 動画をアップロード
        if let url = self.url{
            // メタデータ設定
            let videoMetadata = StorageMetadata()
            videoMetadata.contentType = "video/mp4"
            let fileName = self.et + ".mp4"
            self.ref.child(self.uid).child("event-video").child(fileName).putFile(from: url as URL, metadata: videoMetadata){ _, error in
                if let _ = error{
                    SVProgressHUD.showError(withStatus: "エラー発生！再度お試しください")
                    return
                } else {
                    self.documentUpload(true)
                }
            }
        } else {
            // 動画はアップロードしない
            self.video ? self.documentUpload(true) : self.documentUpload(false)
        }
    }
    
    // ドキュメントをアップロードする
    func documentUpload(_ videoBool: Bool){
        let docRef = Firestore.firestore().collection("EVENTS").document(self.uid)
        
        // ドキュメントデータ
        let key = id + "-video"
        let data: [String: Any] = [
            self.id : [
                "caption" : self.ec as String,
                "eventTitle" : self.et as String,
                "eventDate" : self.ed as String,
                "imageCaptions" : self.imageCaptions as [String],
                "upgrade" : upgrade || UserDefaults.standard.bool(forKey: key) ? true : false,
                "video" : videoBool as Bool
            ]
        ]
        docRef.setData(data, merge: true){ err in
            if let _ = err{
                SVProgressHUD.showError(withStatus: "エラー発生！再度お試しください")
                return
            } else {
                self.imageUpload()
            }
        }
    }
    
    // 画像をアップロードする
    func imageUpload(){
        var uploads = (self.refArray.filter { $0 is UIImage }).count
        if uploads == 0{
            // 新規の画像が無い
            self.imageDeleteFromStorage()
        } else {
            // 新規画像有り
            for (index, data) in self.refArray.enumerated(){
                if data is UIImage{
                    // JPEGに変換して画像をアップロード
                    let fileName = String(self.imageCaptions[index].prefix(10) + ".jpg")
                    let imageData = (data as! UIImage).jpegData(compressionQuality: 0.75)
                    // メタデータ設定
                    let storageMetadata = StorageMetadata()
                    storageMetadata.contentType = "image/jpeg"
                    
                    self.ref.child(self.uid).child("event-image").child(self.et).child(fileName).putData(imageData!, metadata: storageMetadata){ _, error in
                        if let _ = error{
                            SVProgressHUD.showError(withStatus: "エラー発生！再度お試しください")
                            return
                        } else {
                            uploads -= 1
                            if uploads == 0{
                                self.imageDeleteFromStorage()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 画像を削除する
    func imageDeleteFromStorage(){
        var dc = self.deleteArray.count
        if dc >= 1{
            // クラウドから削除する
            for path in self.deleteArray {
                path.delete{ err in
                    if let _ = err {
                        SVProgressHUD.showError(withStatus: "エラー発生！再度お試しください")
                        return
                    } else {
                        dc -= 1
                        if dc == 0{
                            self.dismiss(animated: true, completion: nil)
                            SVProgressHUD.showSuccess(withStatus: "アップロード完了！\n文化祭コンテンツが公開されている場合、「Psyなび for 文化祭&お祭り」アプリで確認できます")
                        }
                    }
                }
            }
        } else {
            // 削除する画像がない
            self.dismiss(animated: true, completion: nil)
            SVProgressHUD.showSuccess(withStatus: "アップロード完了！\n文化祭コンテンツが公開されている場合、「Psyなび for 文化祭&お祭り」アプリで確認できます")
        }
    }
}
