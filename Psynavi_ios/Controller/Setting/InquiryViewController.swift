/*
 お問い合わせの処理
 */

import UIKit

final class InquiryViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var contentsTitle: UITextField!
    @IBOutlet private weak var contents: UITextView!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissKeyboard()
    }
    
    // MARK: - 送信
    @IBAction private func sendContents(_ sender: Any) {
        
        guard let title = contentsTitle.text, let content = contents.text else { return }
        
        if title.isEmpty || content.isEmpty {
            Modal.showError("タイトルと内容を記してください！")
        } else {
            
            let inquiryData: [String:Any] = [
                "title" : title,
                "content" : content,
            ]
            
            PostData.postDocument(inquiryData, PathName.InquiryPath, "", PostMode.inquiry) { result in
                switch result {
                case .success(let text):
                    Modal.showSuccess(text)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
