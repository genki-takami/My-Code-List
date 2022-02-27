/*
 公開オブジェクトのショップ詳細表示の処理
 */

import UIKit

final class ShopViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentTag: UILabel!
    @IBOutlet weak var contentManager: UILabel!
    @IBOutlet weak var contentDate: UILabel!
    @IBOutlet weak var contentPlace: UILabel!
    @IBOutlet weak var contentInfo: UITextView!
    @IBOutlet weak var contentManagerInfo: UITextView!
    @IBOutlet weak var contentImage: UIImageView!
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
        /// 動画を再生する
        startVideo()
    }
}
