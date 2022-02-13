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
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - 送信
    @IBAction private func sendContents(_ sender: Any) {
        
        if let title = contentsTitle.text, let content = contents.text {
            
            if title.isEmpty || content.isEmpty{
                DisplayPop.error("タイトルと内容を記してください！")
            } else {
                
                let postDoc: [String:Any] = [
                    "title" : title,
                    "content" : content,
                ]
                
                PostData.postDocument(postDoc, PathName.InquiryPath, "", PostMode.inquiry) { result in
                    switch result {
                    case .success(let text):
                        DisplayPop.success(text)
                    case .failure(let error):
                        DisplayPop.error(error.localizedDescription)
                    }
                }
            }
        }
    }
}
