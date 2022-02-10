/*
 EventViewControllerの拡張
 */

import UIKit
import AVKit

extension EventViewController {
    
    // セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer){
        collectionView(eventCollection, didSelectItemAt: sender.indexValue!)
    }
    
    // 動画を再生
    func playing(_ url: URL){
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: url)
        
        present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
