/*
 サインアップの処理
 */

import UIKit

final class SignUpViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var displayName: UITextField!
    @IBOutlet private weak var mailAdress: UITextField!
    @IBOutlet private weak var password: UITextField!
    var uid: String!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// サインインしていたらサインアウトする
        if AuthModule.checkout() {
            AuthModule.signOut()
        }
        
        setDismissKeyboard()
    }
    
    // MARK: - SIGN-UP
    @IBAction private func signUp(_ sender: Any) {
        
        guard let address = mailAdress.text, let password = password.text, let displayName = displayName.text else { return }
        signUpOperation(address, password, displayName)
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromSignUpSegue" {
            
            let editMainVC = segue.destination as! EditMainViewController
            guard let mail = mailAdress.text, let pass = password.text else { return }
            /// 作成画面に渡すデータを形成する
            createPsyData(mail, pass, editMainVC)
        }
    }
    
    /// タブ画面に戻る
    @IBAction private func backToTabFromSignUp(_ sender: Any) {
        backToTabbar(at: 3)
    }
}
