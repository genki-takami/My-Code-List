/*
 画像とキャプションの拡大表示
 */

import UIKit

class EventImageShowVC: UIViewController {

    // 変数
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var eventContent: UITextView!
    var image: UIImage!
    var caption: String!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        bigImage.image = image
        eventContent.text = String(caption.dropFirst(10)) as String
    }
    
    // コレクションへ戻る
    @IBAction func backToCollection(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
