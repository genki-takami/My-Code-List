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
        
        // サインインしていたらサインアウトする
        refreshAccount()
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - SIGN-UP
    @IBAction private func signUp(_ sender: Any) {
        
        if let address = mailAdress.text, let password = password.text, let displayName = displayName.text {
            signUpOperation(address, password, displayName)
        }
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromSignUpSegue" {
            let editMainVC = segue.destination as! EditMainViewController
            if let mail = mailAdress.text, let pass = password.text {
                // 作成画面に渡すデータを形成する
                createPsyData(mail, pass, editMainVC)
            }
        }
    }
    
    // タブ画面に戻る
    @IBAction private func backToTabFromSignUp(_ sender: Any) {
        // 作成などタブに戻る
        let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        tabBer.modalPresentationStyle = .fullScreen
        tabBer.selectedIndex = 3
        present(tabBer, animated: true, completion: nil)
    }
}
