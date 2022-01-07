/*
 公開オブジェクトのショップ詳細表示の処理
 */

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD
import AVKit

class ReadingShopContentViewController: UIViewController {

    // 変数
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentTag: UILabel!
    @IBOutlet weak var contentManager: UILabel!
    @IBOutlet weak var contentDate: UILabel!
    @IBOutlet weak var contentPlace: UILabel!
    @IBOutlet weak var contentInfo: UITextView!
    @IBOutlet weak var contentManagerInfo: UITextView!
    @IBOutlet weak var contentImage: UIImageView!
    var uuid, name, date, place, manager, managerInfo, tag, info: String!
    var video: Bool!
    let ref = Storage.storage().reference()
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // テキストデータ
        contentTitle.text = name
        contentTag.text = "タグ：\(String(tag))"
        contentManager.text = manager
        contentDate.text = date
        contentPlace.text = place
        contentInfo.text = info
        contentManagerInfo.text = managerInfo
        // 画像データ
        contentImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        contentImage.sd_setImage(with: ref.child(self.uuid).child(Const.ContentImagePath).child("\(String(self.name)).jpg"))
    }
    
    // 再生準備
    @IBAction func playVideo(_ sender: Any) {
        // クラウドストレージから参照
        if self.video{
            // アップロード済み
            let fileName = name + ".mp4"
            let videoRef = self.ref.child(self.uuid).child("content-video").child(fileName)
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
}
