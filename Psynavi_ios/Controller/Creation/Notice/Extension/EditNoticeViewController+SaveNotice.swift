/*
 EditNoticeViewControllerの拡張
 */

import Foundation

extension EditNoticeViewController: SaveNotice {
    
    func saveNotice(_ title: String, _ content: String) {
        
        if title.isEmpty || content.isEmpty {
            Modal.showError("件名と内容を記入してください！")
            return
        }
        
        Modal.show()
        
        let data: [String:Any] = [
            "noticeTitle": title,
            "noticeContent": content,
            "date": Date(),
        ]
        
        RealmTask.add(notice, data, EditMode.modify, RealmModel.notice) { result in
            switch result {
            case .success(let text):
                self.dismiss(animated: true, completion: nil)
                Modal.showSuccess(text)
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
        }
    }
}
