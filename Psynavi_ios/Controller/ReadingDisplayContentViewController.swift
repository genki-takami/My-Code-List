/*
 公開オブジェクトのディスプレイ詳細表示の処理
 */

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD
import AVKit

class ReadingDisplayContentViewController: UIViewController {
    
    // 変数
    @IBOutlet weak var displayTitle: UILabel!
    @IBOutlet weak var displayTag: UILabel!
    @IBOutlet weak var displayManager: UILabel!
    @IBOutlet weak var displayDate: UILabel!
    @IBOutlet weak var displayPlace: UILabel!
    @IBOutlet weak var displayInfo: UITextView!
    @IBOutlet weak var displayManagerInfo: UITextView!
    @IBOutlet weak var displayImage: UIImageView!
    var uuid, name, date, place, manager, managerInfo, tag, info: String!
    var video: Bool!
    let ref = Storage.storage().reference()
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // テキストデータ
        displayTitle.text = name
        displayTag.text = "タグ：\(String(tag))"
        displayManager.text = manager
        displayDate.text = date
        displayPlace.text = place
        displayInfo.text = info
        displayManagerInfo.text = managerInfo
        // 画像データ
        displayImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        displayImage.sd_setImage(with: ref.child(self.uuid).child(Const.ContentImagePath).child("\(String(self.name)).jpg"))
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
