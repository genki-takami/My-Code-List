/*
 編集オブジェクトのインベントの画像を表示
 */

import UIKit

final class EditEventImagePreviewController: UIViewController {

    // 変数
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var caption: UILabel!
    var selectedImage: UIImage!
    var selectedCaption: String!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        image.image = selectedImage
        caption.text = String(selectedCaption.dropFirst(10)) as String
    }
}
