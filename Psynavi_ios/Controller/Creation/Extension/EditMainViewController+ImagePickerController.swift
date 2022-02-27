/*
 EditMainViewControllerの拡張
 */

import UIKit

extension EditMainViewController: UIImagePickerControllerDelegate {
    
    /// 画像選択画面へ遷移
    func pickingStart(_ sourceType: UIImagePickerController.SourceType, _ title: String) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.modalPresentationStyle = .fullScreen
            pickerController.sourceType = sourceType
            pickerController.title = title
            
            present(pickerController, animated: true, completion: nil)
        } else {
            Modal.showError("この機能はデバイスで無効にされています")
        }
    }
    
    /// 取得した画像をUIImageViewにセット
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let info = info[.originalImage] else { return }
        /// アイコンと背景画像を識別
        switch picker.title {
        case "icon":
            icon.image = info as? UIImage
        case "background":
            background.image = info as? UIImage
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
    }

    /// 画像取得をキャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
