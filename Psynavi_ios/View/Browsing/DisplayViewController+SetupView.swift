/*
 DisplayViewControllerの拡張
 */

import FirebaseStorageUI

extension DisplayViewController {
    
    /// UIのセットアップ
    func setupView() {
        /// テキストデータ
        displayTitle.text = name
        displayTag.text = "タグ：\(String(tag))"
        displayManager.text = manager
        displayDate.text = date
        displayPlace.text = place
        displayInfo.text = info
        displayManagerInfo.text = managerInfo
        /// 画像データ
        displayImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let ref = FetchData.getPath3StorageReference(uuid, PathName.ContentImagePath, "\(String(self.name)).jpg")
        displayImage.sd_setImage(with: ref)
    }
}
