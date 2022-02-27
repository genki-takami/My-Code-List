/*
 公開オブジェクトのディスプレイ詳細表示の処理
 */

import UIKit

final class DisplayViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var displayTitle: UILabel!
    @IBOutlet weak var displayTag: UILabel!
    @IBOutlet weak var displayManager: UILabel!
    @IBOutlet weak var displayDate: UILabel!
    @IBOutlet weak var displayPlace: UILabel!
    @IBOutlet weak var displayInfo: UITextView!
    @IBOutlet weak var displayManagerInfo: UITextView!
    @IBOutlet weak var displayImage: UIImageView!
    var uuid, name, date, place: String!
    var manager, managerInfo, tag, info: String!
    var video: Bool!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - 再生準備
    @IBAction private func playVideo(_ sender: Any) {
        
        /// 動画を再生
        startVideo()
    }
}
