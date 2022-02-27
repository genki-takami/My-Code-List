/*
 EditNoticeViewControllerの拡張
 */

extension EditNoticeViewController {
    
    /// UIのセットアップ
    func setupView() {
        if !notice.noticeTitle.isEmpty {
            noticeTitle.text = notice.noticeTitle
            noticeContent.text = notice.noticeContent
        }
        
        setDismissKeyboard()
    }
}
