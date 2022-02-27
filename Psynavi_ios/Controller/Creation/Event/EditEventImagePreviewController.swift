/*
 編集オブジェクトのインベントの画像を表示
 */

import UIKit

final class EditEventImagePreviewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var caption: UILabel!
    var selectedImage: UIImage!
    var selectedCaption: String!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        /// 画像とキャプションをセット
        image.image = selectedImage
        caption.text = String(selectedCaption.dropFirst(10)) as String
    }
}
