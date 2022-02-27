/*
 EventViewControllerの拡張
 */

import AVKit

extension EventViewController: StartVideo {
    
    /// 動画を再生する
    func startVideo() {
        
        if video {
            /// 動画は投稿済み
            let fileName = self.eventTitle + ".mp4"
            let videoRef = FetchData.getPath3StorageReference(uuid, PathName.EventVideoPath, fileName)

            FetchData.downloadVideo(videoRef) { result in
                switch result {
                case .success(let url):
                    self.playing(url!)
                    self.popAlert()
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        } else {
            Modal.showError("動画は投稿されていません")
        }
    }
    
    /// ストリーミング中であることを知らせる
    private func popAlert() {
        Modal.showMessage("ストリーミング中")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Modal.dismiss()
        }
    }
    
    /// 動画を再生
    private func playing(_ url: URL){
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: url)
        
        present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
