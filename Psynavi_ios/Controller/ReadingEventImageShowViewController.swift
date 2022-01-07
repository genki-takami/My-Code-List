/*
 公開オブジェクトのイベント画像詳細表示の処理
 */

import UIKit

class ReadingEventImageShowViewController: UIViewController {

    // 変数
    @IBOutlet weak var readingBigImage: UIImageView!
    @IBOutlet weak var readingCaption: UILabel!
    var selectedImage: UIImage!
    var selectedCaption: String!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // 画像データ
        readingBigImage.image = selectedImage
        // テキストデータ
        readingCaption.text = String(selectedCaption.dropFirst(10)) as String
    }
}
