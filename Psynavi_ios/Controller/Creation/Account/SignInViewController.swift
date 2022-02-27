/*
 サインインの処理
 */

import UIKit

final class SignInViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var mailAdress: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet weak var accountList: UITextView!
    var pullObject: PsyData!
    var contentImageArray = [String]()
    var eventImageArray = [String]()
    var upgrade: Bool!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// サインインしていたらサインアウトする
        if AuthModule.checkout() {
            AuthModule.signOut()
        }
        /// アカウント履歴がないかチェック
        makeUpAccountRecord()
        
        setDismissKeyboard()
    }
    
    // MARK: - SIGN IN
    @IBAction private func signIn(_ sender: Any) {
        
        guard let address = mailAdress.text, let password = password.text else { return }
        signInOperation(address, password)
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromSignInSegue" {
            let editMainVC = segue.destination as! EditMainViewController
            editMainVC.mailAdress = pullObject.mailAdress
            editMainVC.password = pullObject.password
            editMainVC.saveData = pullObject
            editMainVC.isNewObject = false
            editMainVC.contentImage = contentImageArray
            editMainVC.eventImage = eventImageArray
            editMainVC.upgrade = upgrade
        }
    }
    
    /// タブ画面に戻る
    @IBAction private func backToTab(_ sender: Any) {
        backToTabbar(at: 3)
    }
}
