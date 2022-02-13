/*
 編集オブジェクトのURLの編集処理
 */

import UIKit

final class EditLinkViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var title1: UITextField!
    @IBOutlet private weak var url1: UITextField!
    @IBOutlet private weak var title2: UITextField!
    @IBOutlet private weak var url2: UITextField!
    weak var delegate: DataReturn3?
    var receiveT1 = "", receiveU1 = "", receiveT2 = "", receiveU2 = ""
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // セットアップ
        title1.text = receiveT1
        url1.text = receiveU1
        title2.text = receiveT2
        url2.text = receiveU2
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - SAVE
    @IBAction private func save(_ sender: Any) {
        
        if let t1 = title1.text, let u1 = url1.text, let t2 = title2.text, let u2 = url2.text {
            
            if (t1.isEmpty || u1.isEmpty) && (t2.isEmpty || u2.isEmpty) {
                DisplayPop.error("必ず１セット以上入力して下さい")
                return
            }
            
            // 遷移元にデータを渡して閉じる
            delegate?.returnData3(t1: t1, u1: u1, t2: t2, u2: u2)
            dismiss(animated: true, completion: nil)
            DisplayPop.success("保存しました")
        }
    }
}
