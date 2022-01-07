/*
 お知らせ詳細画面の処理
 */

import UIKit

class NoticePopupViewController: UIViewController {

    // 変数
    @IBOutlet weak var festivalTitle: UILabel!
    @IBOutlet weak var noticeTitleLabel: UILabel!
    @IBOutlet weak var noticeDateLabel: UILabel!
    @IBOutlet weak var noticeContentTextView: UITextView!
    var fesName, noticeTitle, noticeDate, noticeContent: String!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        festivalTitle.text = fesName
        noticeTitleLabel.text = noticeTitle
        noticeDateLabel.text = noticeDate
        noticeContentTextView.text = noticeContent
    }
}
