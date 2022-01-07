/*
 選択した画像のキャプションを入力する画面
 */

import UIKit
import SVProgressHUD

class CaptionEditVC: UIViewController {

    // 変数
    @IBOutlet weak var editCaption: UITextView!
    @IBOutlet weak var selectedImage: UIImageView!
    var image: UIImage!
    var delegate: DataReturn?
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedImage.image = self.image
    }
    
    // キャンセル
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 画像とキャプションを保存する
    @IBAction func completeEdit(_ sender: Any) {
        if let captionText = editCaption.text{
            
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
