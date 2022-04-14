/*
 編集画面のViewModel
 */

import SwiftUI
import FirebaseStorage

final class EditViewModel: ObservableObject {
    
    @Published var editModel: EditModel = EditModel()
    @Published var caption = "お知らせ内容"
    @Published var date = ""
    @Published var videoURL: URL? = nil
    @Published var currentBox: EventImage? = nil
    var deleteList = [StorageReference]()
    var key = ""
    var upgrade = false
    
    func setupView(with data: EventModel?) {
        
        guard let data = data else {
            Modal.showError("データの表示に失敗しました")
            return
        }
        
        editModel.setTitle(data.eventTitle)
        caption = data.caption
        date = data.eventDate
        editModel.setImageCaption(data.imageCaptions)
        editModel.setImageBox(data.imageBox)
        
        /// 動画を追加するのか(=課金するか)、変更するのか
        key = data.uid + "-video"
        upgrade = data.upgrade
        if checkPurchaseStatus() {
            editModel.setVideoLabel("動画を変更")
        }
    }
    
    func checkPurchaseStatus() -> Bool {
        upgrade || UserDefaultsTask.checkPurchased(key) ? true : false
    }
    
    func addWillDelete(at ref: StorageReference) {
        deleteList.append(ref)
    }
}
