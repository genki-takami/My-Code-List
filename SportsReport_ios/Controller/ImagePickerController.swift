/*
 InputViewControllerの拡張
 */

import UIKit

extension InputViewController: UIImagePickerControllerDelegate {
    
    func pickingStart(_ sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = sourceType
            present(pickerController, animated: true, completion: nil)
        } else {
            DisplayPop.error("この機能はデバイスで無効にされています")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let info = info[.originalImage] else { return }
        // 撮影・選択された画像を取得する
        picture.image = info as? UIImage
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
