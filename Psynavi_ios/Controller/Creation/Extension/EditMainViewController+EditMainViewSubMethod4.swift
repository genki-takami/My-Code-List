/*
 EditMainViewControllerの拡張
 */

import Foundation

extension EditMainViewController: EditMainViewSubMethod4 {
    
    /// アップロードループ１
    func uploadLoop1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.successCount < 0.9 ? self.uploadloop2() : self.finishUpload()
        }
    }

    /// アップロードループ２
    func uploadloop2() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.successCount < 0.9 ? self.uploadLoop1() : self.finishUpload()
        }
    }

    /// 作成などタブに戻る
    func finishUpload() {
        deleteTemporaryData()
        signout(2)
    }

    /// プログレスバーを進める
    func stepBar() {
        successCount += 0.2
        progressView.setProgress(successCount, animated: true)
    }
    
    /// サインアウトする
    func signout(_ checkout: Int) {
        
        if let _ = AuthModule.currentUser() {
            AuthModule.signOut()
            checkout == 1 ? Modal.showSuccess("タブ画面に戻ります") : Modal.showSuccess("完了！\nタブ画面に戻ります")
            // 作成などタブに戻る
            backToTabbar(at: 3)
        }
    }
}
