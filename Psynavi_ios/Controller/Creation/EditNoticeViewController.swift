/*
 編集オブジェクトのお知らせの編集処理
 */

import UIKit
import RealmSwift
import SVProgressHUD
import Firebase

final class EditNoticeViewController: UIViewController {
    
    // 変数
    @IBOutlet weak var noticeTitle: UITextField!
    @IBOutlet weak var noticeContent: UITextView!
    let realm = try! Realm()
    var notice: NoticeDB!

    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !notice.noticeTitle.isEmpty{
            self.noticeTitle.text = notice.noticeTitle
            self.noticeContent.text = notice.noticeContent
        }

        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 遷移元のライフサイクルメソッドを維持する
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
        }
        super.viewWillAppear(animated)
    }
    
    // 遷移元のライフサイクルメソッドを維持する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    // 遷移元のライフサイクルメソッドを維持する
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    // お知らせを保存
    @IBAction func save(_ sender: Any) {
        if let title = noticeTitle.text, let content = noticeContent.text{
            
            if title.isEmpty || content.isEmpty{
                SVProgressHUD.showError(withStatus: "件名と内容を記入してください！")
                return
            }
            
            SVProgressHUD.show()
            
            do {
                try realm.write {
                    self.notice.noticeTitle = title
                    self.notice.noticeContent = content
                    self.notice.date = Date()
                    self.realm.add(self.notice, update: .modified)
                }
            } catch _ as NSError {
                Analytics.logEvent("error_NoticeEditViewController_save", parameters: [AnalyticsParameterItemName:"お知らせの作成・編集に失敗" as String])
                SVProgressHUD.showError(withStatus: "\(title)の保存に失敗しました")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            SVProgressHUD.showSuccess(withStatus: "保存しました！")
        }
    }
}
