/*
 EditMainViewControllerの拡張
 */

import Foundation

extension EditMainViewController: EditMainViewSubMethod3 {
    
    /// メインデータを保存する
    func savingData(_ name: String) -> Bool {
        
        if name.isEmpty {
            Modal.showError("文化祭名を記入してください！")
            return false
        }
        
        /// アイコン画像と背景画像は必ず必要
        let iconJPEG = icon.image?.jpegData(compressionQuality: 0.75)
        let iconSize = NSData(data: iconJPEG!).count
        let backgroundJPEG = background.image?.jpegData(compressionQuality: 0.75)
        let backgroundSize = NSData(data: backgroundJPEG!).count
        
        if iconSize == 0 || backgroundSize == 0 {
            Modal.showError("アイコン画像と背景画像を選択してください")
            return false
        }
        
        /// アカウント作成履歴を作る
        let accountNameText = accountName.text!
        if var accountList = UserDefaultsTask.getAccountData("accountList") {
            /// アカウント履歴がある
            if accountList.first(where: { $0 == accountNameText }) == nil {
                accountList.append(accountNameText)
                UserDefaultsTask.setAccountData(accountList, "accountList")
            }
        } else {
            /// アカウント履歴がない
            let initList: [String] = [accountNameText]
            UserDefaultsTask.setAccountData(initList, "accountList")
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
    
    /// テキストを初期化する
    private func initializingText(_ text: String) -> String {
        
        if text.isEmpty {
            return "----"
        } else {
            return text
        }
    }
}

extension EditMainViewController: DataReturn3 {
    
    /// URLデータを受け取る
    func returnData3(t1: String, u1: String, t2: String, u2: String) {
        title1 = t1
        url1 = u1
        title2 = t2
        url2 = u2
    }
}
