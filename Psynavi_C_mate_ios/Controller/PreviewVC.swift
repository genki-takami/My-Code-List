/*
 確認画面
 */

import UIKit
import Firebase
import SVProgressHUD
import AVFoundation
import AVKit

class PreviewVC: UIViewController {
    
    // 変数
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentTag: UILabel!
    @IBOutlet weak var contentManager: UILabel!
    @IBOutlet weak var contentDate: UILabel!
    @IBOutlet weak var contentPlace: UILabel!
    @IBOutlet weak var contentInfo: UITextView!
    @IBOutlet weak var contentManagerInfo: UITextView!
    var uid, id, name, tag, manager, date, place, info, managerInfo: String!
    var upgrade, video, newImage: Bool!
    var url: NSURL!
    var image: UIImage!
    let ref = Storage.storage().reference()
    
    // 読み込む
    override func viewDidLoad() {
        super.viewDidLoad()

        // テキストデータ
        contentTitle.text = name
        contentTag.text = tag
        contentManager.text = manager
        contentDate.text = date
        contentPlace.text = place
        contentInfo.text = info
        contentManagerInfo.text = managerInfo
        // 画像データ
        contentImage.image = image
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
                    let fileName = name + ".mp4"
                    let videoRef = self.ref.child(self.uid).child("content-video").child(fileName)
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
    
    // 保存
    @IBAction func save(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "アップロード中...")
        // 動画をアップロード
        if let url = self.url{
            // メタデータ設定
            let videoMetadata = StorageMetadata()
            videoMetadata.contentType = "video/mp4"
            let fileName = name + ".mp4"
            self.ref.child(self.uid).child("content-video").child(fileName).putFile(from: url as URL, metadata: videoMetadata){ _, error in
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
        let docRef = Firestore.firestore().collection("CONTENTS").document(self.uid)
        
        // ドキュメントデータ
        let key = id + "-video"
        let data: [String: Any] = [
            self.id : [
                "name" : name as String,
                "manager" : manager as String,
                "date" : date as String,
                "place" : place as String,
                "tag" : tag as String,
                "info" : info as String,
                "managerInfo" : managerInfo as String,
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
        if newImage{
            // 画像をアップロード
            // JPEGに変換
            let fileName = self.name + ".jpg"
            let imageData = self.image.jpegData(compressionQuality: 0.75)
            // メタデータ設定
            let storageMetadata = StorageMetadata()
            storageMetadata.contentType = "image/jpeg"
            self.ref.child(self.uid).child("content-image").child(fileName).putData(imageData!, metadata: storageMetadata){ _, error in
                if let _ = error{
                    SVProgressHUD.showError(withStatus: "エラー発生！再度お試しください")
                    return
                } else {
                    self.dismiss(animated: true, completion: nil)
                    SVProgressHUD.showSuccess(withStatus: "アップロード完了！\n文化祭コンテンツが公開されている場合、「Psyなび for 文化祭&お祭り」アプリで確認できます")
                }
            }
        } else {
            // 新しい画像をアップロードしない
            self.dismiss(animated: true, completion: nil)
            SVProgressHUD.showSuccess(withStatus: "アップロード完了！\n文化祭コンテンツが公開されている場合、「Psyなび for 文化祭&お祭り」アプリで確認できます")
        }
    }
    
    // 編集画面に戻る
    @IBAction func backToEdit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
