/*
 EditMainViewControllerの拡張
 */

import UIKit

extension EditMainViewController: EditMainViewSubMethod1 {
    
    /// 注意書きを表示
    func popMessage() {
        
        if !alertFinish {
            let message = "＜新規作成の場合＞\nすべての情報を追加・編集できます。\n＜ログインの場合＞\nショップ/展示およびお知らせ、イベントの情報は新規追加のみになります。編集をする場合、Webブラウザにて「PsyなびStudio」をご利用ください。"
            let alertController = UIAlertController(title: "重要", message: message, preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Let's start!", style: .default){ action in
                self.alertFinish = true
            }
            alertController.addAction(actionYes)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    /// ログアウトするかの確認を表示
    func signOutCheck() {
        
        let alertController = UIAlertController(title: "ログアウトしますか？", message: "タブ画面に戻ります", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "はい", style: .destructive){ action in
            /// データを削除してからログアウト
            self.deleteTemporaryData()
            self.signout(1)
        }
        let actionCancel = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
