/*
 お知らせ詳細画面の処理
 */

import UIKit

final class NoticePopupViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var festivalTitle: UILabel!
    @IBOutlet private weak var noticeTitleLabel: UILabel!
    @IBOutlet private weak var noticeDateLabel: UILabel!
    @IBOutlet private weak var noticeContentTextView: UITextView!
    var fesName: String!
    var noticeTitle: String!
    var noticeDate: String!
    var noticeContent: String!
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidLoad() {
        super.viewDidLoad()

        festivalTitle.text = fesName
        noticeTitleLabel.text = noticeTitle
        noticeDateLabel.text = noticeDate
        noticeContentTextView.text = noticeContent
    }
}
