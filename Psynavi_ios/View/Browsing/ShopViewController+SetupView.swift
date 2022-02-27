/*
 ShopViewControllerの拡張
 */

import FirebaseStorageUI

extension ShopViewController {
    
    /// UIのセットアップ
    func setupView() {
        /// テキストデータ
        contentTitle.text = name
        contentTag.text = "タグ：\(String(tag))"
        contentManager.text = manager
        contentDate.text = date
        contentPlace.text = place
        contentInfo.text = info
        contentManagerInfo.text = managerInfo
        /// 画像データ
        contentImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let ref = FetchData.getPath3StorageReference(uuid, PathName.ContentImagePath, "\(String(self.name)).jpg")
        contentImage.sd_setImage(with: ref)
    }
}
