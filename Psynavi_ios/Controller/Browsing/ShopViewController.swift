/*
 公開オブジェクトのショップ詳細表示の処理
 */

import UIKit
import FirebaseUI
import AVKit

final class ShopViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var contentTitle: UILabel!
    @IBOutlet private weak var contentTag: UILabel!
    @IBOutlet private weak var contentManager: UILabel!
    @IBOutlet private weak var contentDate: UILabel!
    @IBOutlet private weak var contentPlace: UILabel!
    @IBOutlet private weak var contentInfo: UITextView!
    @IBOutlet private weak var contentManagerInfo: UITextView!
    @IBOutlet private weak var contentImage: UIImageView!
    var uuid, name, date, place: String!
    var manager, managerInfo, tag, info: String!
    var video: Bool!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpShopData()
    }
    
    // MARK: - 再生準備
    @IBAction private func playVideo(_ sender: Any) {
        
        if video {
            // 動画は投稿されている
            let fileName = name + ".mp4"
            let videoRef = FetchData.getPath3StorageReference(uuid, PathName.ContentVideoPath, fileName)
            
            FetchData.downloadVideo(videoRef) { result in
                switch result {
                case .success(let url):
                    self.playing(url!)
                    self.popAlert()
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        } else {
            DisplayPop.error("動画は投稿されていません")
        }
    }
    
    // MARK: - SET-UP
    private func setUpShopData() {
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
        let ref = FetchData.getPath3StorageReference(uuid, PathName.ContentImagePath, "\(String(self.name)).jpg")
        contentImage.sd_setImage(with: ref)
    }
    
    // ストリーミング中であることを知らせる
    private func popAlert() {
        DisplayPop.showMessage("ストリーミング中")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            DisplayPop.dismiss()
        }
    }
    
    // 動画を再生
    private func playing(_ url: URL) {
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: url)
        
        present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
