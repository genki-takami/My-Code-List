/*
 編集オブジェクトのイベントの画像のキャプションの編集処理
 */

import UIKit

final class EditEventImageViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var caption: UITextView!
    @IBOutlet private weak var bigImage: UIImageView!
    weak var delegate: DataReturn?
    var image: UIImage!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        
        bigImage.image = image
        setDismissKeyboard()
    }
    
    // MARK: - CANCEL
    @IBAction private func didCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - SAVE
    @IBAction private func didSaveButton(_ sender: Any) {
        
        guard let captionText = caption.text else { return }
        
        if captionText.isEmpty {
            Modal.showError("文字を入力してください！")
            return
        }
        
        /// キャプションにUUIDをつける
        let text = String(NSUUID().uuidString.prefix(10) + captionText) as String
        /// データを遷移元に渡す
        delegate?.returnData(imageData: image, captionData: text)
        /// ２つ前の画面に戻る
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
