/*
 編集オブジェクトのURLの編集処理
 */

import UIKit
import SVProgressHUD

class URLViewController: UIViewController {

    // 変数
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var url1: UITextField!
    @IBOutlet weak var title2: UITextField!
    @IBOutlet weak var url2: UITextField!
    var delegate: DataReturn3?
    var receiveT1 = "", receiveU1 = "", receiveT2 = "", receiveU2 = ""
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // セットアップ
        self.title1.text = self.receiveT1
        self.url1.text = self.receiveU1
        self.title2.text = self.receiveT2
        self.url2.text = self.receiveU2
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 保存
    @IBAction func save(_ sender: Any) {
        if let t1 = title1.text, let u1 = url1.text, let t2 = title2.text, let u2 = url2.text{
            
            if (t1.isEmpty || u1.isEmpty) && (t2.isEmpty || u2.isEmpty){
                SVProgressHUD.showError(withStatus: "必ず１セット以上入力して下さい")
                return
            }
            // 遷移元にデータを渡して閉じる
            delegate?.returnData3(t1: t1, u1: u1, t2: t2, u2: u2)
            self.dismiss(animated: true, completion: nil)
            SVProgressHUD.showSuccess(withStatus: "保存しました")
        }
    }
}
