/*
 SignInViewControllerの拡張
 */

import UIKit

extension SignInViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // サインインしていたらサインアウトする
    func refreshAccount() {
        if AuthModule.checkout() {
            AuthModule.signOut()
        }
    }
    
    // アカウント履歴がないかチェック
    func makeUpAccountRecord() {
        
        if let accounts = DataProcessing.getAccountData("accountList") {
            accountList.text = "アカウントの作成履歴\n"
            for account in accounts {
                let list = accountList.text
                // 履歴を追加していく
                accountList.text = list! + "・" + account + "\n"
            }
        }
    }
    
    // ログイン
    func signInOperation(_ address: String, _ password: String) {
        
        // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
        if address.isEmpty || password.isEmpty {
            DisplayPop.error("必要項目を入力して下さい")
            return
        }

        DisplayPop.showMessage("ログインとデータの同期中")
        
        AuthModule.signIn(address, password) { result in
            switch result {
            case .success(let uid):
                self.fetchingData(uid: uid, mail: address, pass: password)
            case .failure(let error):
                DisplayPop.error(error.localizedDescription)
            }
        }
    }
    
    // データを持ってくる
    private func fetchingData(uid: String, mail: String, pass: String) {
        
        FetchData.fetchDocument(PathName.DraftPath, uid) { result in
            switch result {
            case .success(let data):
                // データを形成する
                self.makePullObject(data, uid, mail, pass)
                // 作成画面へGo!
                DisplayPop.dismiss()
                self.performSegue(withIdentifier: "fromSignInSegue", sender: nil)
                
            case .failure(let error):
                if !(error.localizedDescription.isEmpty) {
                    DisplayPop.error(FirebaseError.syncDataError.localizedDescription)
                    AuthModule.signOut()
                }
            }
        }
    }
    
    // データを形成する
    private func makePullObject(_ data: [String:Any], _ uid: String, _ mail: String, _ pass: String) {
        // 基本データ
        pullObject = PsyData()
        pullObject.mailAdress = mail
        pullObject.password = pass
        pullObject.uuid = uid
        // メインデータ
        pullObject.festivalName = data["festivalName"] as? String ?? ""
        pullObject.date = data["date"] as? String ?? ""
        pullObject.school = data["school"] as? String ?? ""
        pullObject.slogan = data["slogan"] as? String ?? ""
        pullObject.info = data["info"] as? String ?? ""
        let linkArray: [String:String] = data["link"] as? [String:String] ?? ["title1":"", "title2":"", "url1":"", "url2":""]
        pullObject.title1 = linkArray["title1"] ?? ""
        pullObject.url1 = linkArray["url1"] ?? ""
        pullObject.title2 = linkArray["title2"] ?? ""
        pullObject.url2 = linkArray["url2"] ?? ""
        pullObject.latitude = data["latitude"] as? Double ?? 35.681236
        pullObject.longitude = data["longitude"] as? Double ?? 139.767125
        let database: [String:Any] = data["database"] as! [String:Any]
        pullObject.published = database["published"] as? Bool ?? false
        pullObject.shop = database["shop"] as? Int ?? 0
        pullObject.display = database["display"] as? Int ?? 0
        pullObject.event = database["event"] as? Int ?? 0
        pullObject.marker = database["marker"] as? Int ?? 0
        pullObject.notice = database["notice"] as? Int ?? 0
        pullObject.icon = database["icon"] as? String ?? ""
        pullObject.background = database["background"] as? String ?? ""
        contentImageArray = database["contentImage"] as? [String] ?? []
        eventImageArray = database["eventImage"] as? [String] ?? []
        upgrade = data["upgrade"] as? Bool ?? false
    }
}
