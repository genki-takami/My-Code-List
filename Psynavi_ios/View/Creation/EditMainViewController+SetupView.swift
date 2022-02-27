/*
 EditMainViewControllerの拡張
 */

import FirebaseStorageUI

extension EditMainViewController {
    
    /// UIをセットアップ
    func setupView() {
        
        if isNewObject {
            /// オプション機能の課金状態をセット
            upgrade = false
        } else {
            name.text = saveData.festivalName
            date.text = saveData.date
            school.text = saveData.school
            slogan.text = saveData.slogan
            info.text = saveData.info
            title1 = saveData.title1
            url1 = saveData.url1
            title2 = saveData.title2
            url2 = saveData.url2
            /// 画像データを表示
            if !saveData.icon.isEmpty {
                icon.sd_imageIndicator = SDWebImageActivityIndicator.gray
                icon.sd_setImage(with: FetchData.getReference(saveData.icon))
            }
            if !saveData.background.isEmpty {
                background.sd_imageIndicator = SDWebImageActivityIndicator.gray
                background.sd_setImage(with: FetchData.getReference(saveData.background))
            }
        }
        
        /// オプション機能の課金状態をセット
        UserDefaultsTask.setPersonalData(upgrade!, saveData.uuid)
        
        /// アカウント名の表示
        if let user = AuthModule.currentUser() {
            accountName.text = String(user.displayName!)
        }
        
        /// キーボードを閉じる
        setDismissKeyboard()
        
        /// プログレスバーの高さを10倍にする
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
    }
}
