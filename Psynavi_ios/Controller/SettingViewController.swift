/*
 その他タブの処理
 */

import UIKit

class SettingViewController: UIViewController {

    // iPhoneの設定アプリまで飛ぶ
    @IBAction func goToSetting(_ sender: Any) {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                // iOS10以降
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
