/*
 EditEventViewControllerの拡張
 */

import UIKit

extension EditEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 画像選択画面へ遷移
    func pickingStart(_ sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.modalPresentationStyle = .fullScreen
            pickerController.sourceType = sourceType
            
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    /// 選択した画像をもとに、キャプション設定画面に遷移
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let info = info[.originalImage] {
            let editEventImageVC = self.storyboard?.instantiateViewController(withIdentifier: "EventImageCreate") as! EditEventImageViewController
            editEventImageVC.image = info as? UIImage
            editEventImageVC.delegate = self
            
            picker.present(editEventImageVC, animated: true, completion: nil)
        }
    }

    /// ピッカーをキャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
