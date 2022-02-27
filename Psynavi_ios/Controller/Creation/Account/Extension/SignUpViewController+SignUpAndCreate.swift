/*
 SignUpViewControllerの拡張
 */

extension SignUpViewController: SignUpAndCreate {
    
    /// アカウントを登録する
    func signUpOperation(_ address: String, _ password: String, _ displayName: String) {
        /// アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
        if address.isEmpty || password.isEmpty || displayName.isEmpty {
            Modal.showError("必要項目を入力して下さい")
            return
        }
        
        Modal.show()

        /// アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログイン
        AuthModule.createUser(address, password, displayName) { result in
            switch result {
            case .success(let user):
                self.uid = user.uid
                self.performSegue(withIdentifier: "fromSignUpSegue", sender: nil)
                Modal.showSuccess("登録が完了しました！")
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
        }
    }
    
    /// 作成画面に渡すデータを形成する
    func createPsyData(_ mail: String, _ pass: String, _ editMainVC: EditMainViewController) {
        /// 基本データの挿入
        let data = PsyData()
        data.mailAdress = mail
        data.password = pass
        data.uuid = uid
        /// 新規作成
        editMainVC.saveData = data
        editMainVC.mailAdress = mail
        editMainVC.password = pass
        editMainVC.isNewObject = true
    }
}
