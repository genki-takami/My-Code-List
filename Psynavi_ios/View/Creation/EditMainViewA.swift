/*
 EditMainViewControllerの拡張
 */

import UIKit
import FirebaseUI

extension EditMainViewController {
    
    // UIをセットアップする
    func setUpUIData() {
        
        if isNewObject {
            // オプション機能の課金状態
            upgrade = false
            DataProcessing.setPersonalData(upgrade!, saveData.uuid)
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
            // 画像データを表示
            if !saveData.icon.isEmpty {
                icon.sd_imageIndicator = SDWebImageActivityIndicator.gray
                icon.sd_setImage(with: FetchData.getReference(saveData.icon))
            }
            if !saveData.background.isEmpty {
                background.sd_imageIndicator = SDWebImageActivityIndicator.gray
                background.sd_setImage(with: FetchData.getReference(saveData.background))
            }
            // オプション機能の課金状態
            DataProcessing.setPersonalData(upgrade!, saveData.uuid)
        }
        
        // アカウント名の表示
        if let user = AuthModule.currentUser() {
            accountName.text = String(user.displayName!)
        }
        
        // プログレスバーの縦幅を10倍にする
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
    }
    
    // 注意書きを表示
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
    
    // ログアウトするかの確認を表示
    func signOutCheck() {
        
        let alertController = UIAlertController(title: "ログアウトしますか？", message: "タブ画面に戻ります", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "はい", style: .destructive){ action in
            // データを削除してからログアウト
            self.deleteRealmDatabase()
            self.signout(1)
        }
        let actionCancel = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
