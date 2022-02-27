/*
 公開オブジェクトのイベント画像詳細表示の処理
 */

import UIKit

final class EventImageViewController: UIViewController {

    // 変数
    @IBOutlet private weak var readingBigImage: UIImageView!
    @IBOutlet private weak var readingCaption: UILabel!
    var selectedImage: UIImage!
    var selectedCaption: String!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // 画像データ
        readingBigImage.image = selectedImage
        // テキストデータ(最初の10行はIDのため切り取る)
        readingCaption.text = String(selectedCaption.dropFirst(10)) as String
    }
}
