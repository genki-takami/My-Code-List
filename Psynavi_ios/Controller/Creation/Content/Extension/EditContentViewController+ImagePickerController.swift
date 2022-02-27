/*
 EditContentViewControllerの拡張
 */

import UIKit

extension EditContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 画像選択画面へ遷移
    func pickingStart(_ sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.modalPresentationStyle = .fullScreen
            pickerController.sourceType = sourceType
            
            present(pickerController, animated: true, completion: nil)
        } else {
            Modal.showError("この機能はデバイスで無効にされています")
        }
    }
    
    /// 取得した画像をUIImageViewにセット
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let info = info[.originalImage] {
            // 選択された画像を表示して、ピッカーを閉じる
            selectedImage.image = info as? UIImage
            dismiss(animated: true, completion: nil)
        }
    }

    /// 画像取得をキャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
