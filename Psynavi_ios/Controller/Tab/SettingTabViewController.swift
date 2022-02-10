/*
 作成などタブの処理
 */

import UIKit

final class SettingTabViewController: UIViewController {

    // iPhoneの設定アプリまで飛ぶ
    @IBAction private func goToSetting(_ sender: Any) {
        
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
