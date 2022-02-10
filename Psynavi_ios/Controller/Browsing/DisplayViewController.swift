/*
 公開オブジェクトのディスプレイ詳細表示の処理
 */

import UIKit
import FirebaseUI
import AVKit

final class DisplayViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var displayTitle: UILabel!
    @IBOutlet private weak var displayTag: UILabel!
    @IBOutlet private weak var displayManager: UILabel!
    @IBOutlet private weak var displayDate: UILabel!
    @IBOutlet private weak var displayPlace: UILabel!
    @IBOutlet private weak var displayInfo: UITextView!
    @IBOutlet private weak var displayManagerInfo: UITextView!
    @IBOutlet private weak var displayImage: UIImageView!
    var uuid, name, date, place: String!
    var manager, managerInfo, tag, info: String!
    var video: Bool!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDisplayData()
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
    private func setUpDisplayData() {
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
        let ref = FetchData.getPath3StorageReference(uuid, PathName.ContentImagePath, "\(String(self.name)).jpg")
        displayImage.sd_setImage(with: ref)
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
