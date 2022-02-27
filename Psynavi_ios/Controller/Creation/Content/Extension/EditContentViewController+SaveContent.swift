/*
 EditContentViewControllerの拡張
 */

import Foundation

extension EditContentViewController: SaveContent {
    
    /// ショップ情報と展示情報を保存
    func saveContent(_ name: String, _ manager: String) {
        
        if name.isEmpty || manager.isEmpty {
            Modal.showError("ショップ名/展示名および運営団体名を記入して下さい！")
            return
        }
        
        if NSData(data: (selectedImage.image?.jpegData(compressionQuality: 0.75))!).count == 0 {
            Modal.showError("画像を選択してください")
            return
        }
        
        Modal.show()
        
        let data: [String:Any] = [
            "name": name,
            "switchFlag": isShop,
            "manager": manager,
            "date": initializingText(date.text!),
            "place": initializingText(place.text!),
            "image": (selectedImage.image?.jpegData(compressionQuality: 0.75)!)!,
            "tag": initializingText(tag.text!),
            "info": initializingText(infoText.text),
            "managerInfo": initializingText(managerInfo.text),
        ]
        
        RealmTask.add(content, data, EditMode.modify, RealmModel.content) { result in
            switch result {
            case .success(let text):
                self.dismiss(animated: true, completion: nil)
                Modal.showSuccess(text)
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
        }
    }
    
    /// テキストが入力されていなかったら"----"に置き換える
    private func initializingText(_ text: String) -> String {
        if text.isEmpty {
            return "----"
        } else {
            return text
        }
    }
}
