/*
 EditMainViewControllerの拡張
 */

import UIKit

extension EditMainViewController: DataReturn3 {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // URLデータを受け取る
    func returnData3(t1: String, u1: String, t2: String, u2: String) {
        title1 = t1
        url1 = u1
        title2 = t2
        url2 = u2
    }
    
    // サインアウトする
    func signout(_ checkout: Int) {
        
        if let _ = AuthModule.currentUser() {
            AuthModule.signOut()
            checkout == 1 ? DisplayPop.success("タブ画面に戻ります") : DisplayPop.success("完了！\nタブ画面に戻ります")
            // 作成などタブに戻る
            let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            tabBer.modalPresentationStyle = .fullScreen
            tabBer.selectedIndex = 3
            
            present(tabBer, animated: true, completion: nil)
        }
    }
    
    // メインデータを保存する
    func savingData() -> Bool {
        
        guard let name = name.text else { fatalError() }
        
        if name.isEmpty {
            DisplayPop.error("文化祭名を記入してください！")
            return false
        }
        
        let iconJPEG = icon.image?.jpegData(compressionQuality: 0.75)
        let iconSize = NSData(data: iconJPEG!).count
        let backgroundJPEG = background.image?.jpegData(compressionQuality: 0.75)
        let backgroundSize = NSData(data: backgroundJPEG!).count
        if iconSize == 0 || backgroundSize == 0 {
            DisplayPop.error("アイコン画像と背景画像を選択してください")
            return false
        }
        
        // アカウント作成履歴を作る
        let an = accountName.text ?? "NO-NAME"
        if var accountList = DataProcessing.getAccountData("accountList") {
            if accountList.first(where: { $0 == an }) == nil {
                accountList.append(an)
                DataProcessing.setAccountData(accountList, "accountList")
            }
        } else {
            let initList: [String] = [an]
            DataProcessing.setAccountData(initList, "accountList")
        }
        
        saveData.festivalName = name
        saveData.date = initializingText(date.text!)
        saveData.school = initializingText(school.text!)
        saveData.slogan = initializingText(slogan.text!)
        saveData.info = initializingText(info.text!)
        saveData.iconImage = (icon.image?.jpegData(compressionQuality: 0.75))!
        saveData.backgroundImage = (background.image?.jpegData(compressionQuality: 0.75))!
        saveData.title1 = title1
        saveData.url1 = url1
        saveData.title2 = title2
        saveData.url2 = url2
        
        return true
    }
    
    // テキストを初期化する
    private func initializingText(_ text: String) -> String {
        
        if text.isEmpty {
            return "----"
        } else {
            return text
        }
    }
}
