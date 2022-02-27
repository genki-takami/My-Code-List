/*
 EditContentViewControllerの拡張
 */

import UIKit

extension EditContentViewController {
    
    /// UIのセットアップ
    func setupView() {
        
        if !content.name.isEmpty {
            /// 編集セットアップ
            shopOrDisplaySwitch.isOn = content.switchFlag
            isShop = content.switchFlag
            name.text = content.name
            managerName.text = content.manager
            date.text = content.date
            place.text = content.place
            selectedImage.image = UIImage(data: content.image)
            tag.text = content.tag
            infoText.text = content.info
            managerInfo.text = content.managerInfo
        }
        
        setDismissKeyboard()
    }
}
