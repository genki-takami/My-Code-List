/*
 編集画面のViewModel
 */

import Foundation
import SwiftUI

final class EditViewModel: ObservableObject {
    
    @Published var editModel: EditModel = EditModel()
    @Published var manager = ""
    @Published var date = ""
    @Published var place = ""
    @Published var tag = ""
    @Published var info = "ここに説明を書く(100文字以内)"
    @Published var managerInfo = "ここに団体情報を書く(100文字以内)"
    @Published var isNewImage = false
    @Published var videoURL: URL? = nil
    var key = ""
    var upgrade = false
    
    func setupView(with data: ShopDisplayModel?) {
        
        guard let data = data else {
            Modal.showError("データの表示に失敗しました")
            return
        }
        
        editModel.setTitle(data.name)
        manager = data.manager
        date = data.date
        place = data.place
        tag = data.tag
        info = data.info
        managerInfo = data.managerInfo
        editModel.setImageURL(data.url)
        
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
}
