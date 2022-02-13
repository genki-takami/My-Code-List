/*
 EditMainViewControllerの拡張
 */

import UIKit

extension EditMainViewController: UIImagePickerControllerDelegate {
    
    func pickingStart(_ sourceType: UIImagePickerController.SourceType, _ title: String) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.modalPresentationStyle = .fullScreen
            pickerController.sourceType = sourceType
            pickerController.title = title
            
            present(pickerController, animated: true, completion: nil)
        } else {
            DisplayPop.error("この機能はデバイスで無効にされています")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let info = info[.originalImage] else { return }
        // 選択された画像を設置する
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

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
