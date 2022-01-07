/*
 タブのコントローラー
 */

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate  {

    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    // タブバーのアイコンタップ処理
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
