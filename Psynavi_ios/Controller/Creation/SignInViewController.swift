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
        
        refreshAccount()
        makeUpAccountRecord()
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - SIGN IN
    @IBAction private func signIn(_ sender: Any) {
        
        if let address = mailAdress.text, let password = password.text {
            signInOperation(address, password)
        }
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
    
    // タブ画面に戻る
    @IBAction private func backToTab(_ sender: Any) {
        // 作成などタブに戻る
        let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        tabBer.modalPresentationStyle = .fullScreen
        tabBer.selectedIndex = 3
        present(tabBer, animated: true, completion: nil)
    }
}
