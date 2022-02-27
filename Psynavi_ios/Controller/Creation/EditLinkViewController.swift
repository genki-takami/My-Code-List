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
        
        setupView()
    }
    
    private func setupView() {
        title1.text = receiveT1
        url1.text = receiveU1
        title2.text = receiveT2
        url2.text = receiveU2
        
        setDismissKeyboard()
    }
    
    // MARK: - SAVE
    @IBAction private func save(_ sender: Any) {
        
        guard let t1 = title1.text, let u1 = url1.text, let t2 = title2.text, let u2 = url2.text else {
            return
        }
        
        if (t1.isEmpty || u1.isEmpty) && (t2.isEmpty || u2.isEmpty) {
            Modal.showError("必ず１セット以上入力して下さい")
            return
        }
        
        /// 遷移元にデータを渡して閉じる
        delegate?.returnData3(t1: t1, u1: u1, t2: t2, u2: u2)
        dismiss(animated: true, completion: nil)
        Modal.showSuccess("保存しました")
    }
}
