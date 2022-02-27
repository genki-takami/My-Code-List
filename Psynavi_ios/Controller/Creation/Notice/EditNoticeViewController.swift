/*
 編集オブジェクトのお知らせの編集処理
 */

import UIKit

final class EditNoticeViewController: CreationUIViewController {
    
    // MARK: - Property
    @IBOutlet weak var noticeTitle: UITextField!
    @IBOutlet weak var noticeContent: UITextView!
    var notice: Notices!

    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - SAVE
    @IBAction private func save(_ sender: Any) {
        
        guard let title = noticeTitle.text, let content = noticeContent.text else { return }
        saveNotice(title, content)
    }
}
