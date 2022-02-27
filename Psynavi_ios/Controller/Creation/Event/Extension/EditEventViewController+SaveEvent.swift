/*
 EditEventViewControllerの拡張
 */

import UIKit

extension EditEventViewController: SaveEvent {
    
    func saveEvent(_ name: String, _ content: String, _ date: String) {
        
        if name.isEmpty || content.isEmpty || date.isEmpty {
            Modal.showError("タイトル/内容/日時を記入してください！")
            return
        }
        
        Modal.show()
        
        let data: [String:Any] = [
            "eventTitle": name,
            "caption": content,
            "eventDate": date,
        ]
        
        RealmTask.add(event, data, EditMode.modify, RealmModel.event) { result in
            switch result {
            case .success(let text):
                self.dismiss(animated: true, completion: nil)
                Modal.showSuccess(text)
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
        }
    }
}

extension EditEventViewController: DataReturn {
    
    // 受け取ったデータをデータベースに保存
    func returnData(imageData: UIImage, captionData: String) {
        
        let data: [String:Any] = [
            "imageProcess": true,
            "imageData": imageData.jpegData(compressionQuality: 0.75)!,
            "captionData": captionData,
        ]
        
        RealmTask.add(event, data, EditMode.modify, RealmModel.event) { result in
            switch result {
            case .success(let text):
                Modal.showSuccess(text)
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
            self.imageCollection.reloadData()
        }
    }
}
