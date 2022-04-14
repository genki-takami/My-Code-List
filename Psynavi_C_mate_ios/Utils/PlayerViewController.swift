/*
 動画の再生処理
 */

import SwiftUI
import AVKit

struct PlayerViewController: UIViewControllerRepresentable {
    
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        
        let controller =  AVPlayerViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.player = player
        controller.videoGravity = .resizeAspect
        
        return controller
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        
    }
}
