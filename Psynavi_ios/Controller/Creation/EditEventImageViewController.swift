/*
 編集オブジェクトのイベントの画像のキャプションの編集処理
 */

import UIKit
import SVProgressHUD

final class EditEventImageViewController: UIViewController {

    // 変数
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var bigImage: UIImageView!
    weak var delegate: DataReturn?
    var image: UIImage!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        bigImage.image = self.image
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // キャンセル
    @IBAction func didCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存
    @IBAction func didSaveButton(_ sender: Any) {
        if let captionText = caption.text{
            
            if captionText.isEmpty{
                SVProgressHUD.showError(withStatus: "文字を入力してください！")
                return
            }
            // キャプションにUUIDをつける
            let text = String(NSUUID().uuidString.prefix(10) + captionText) as String
            // データを遷移元に渡す
            delegate?.returnData(imageData: self.image, captionData: text)
            // ２つ前の画面に戻る
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
