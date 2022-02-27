/*
 編集オブジェクトのコンテンツの編集処理
 */

import UIKit

final class EditContentViewController: CreationUIViewController {
    
    // MARK: - Property
    @IBOutlet weak var shopOrDisplaySwitch: UISwitch!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var managerName: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var tag: UITextField!
    @IBOutlet weak var infoText: UITextView!
    @IBOutlet weak var managerInfo: UITextView!
    var isShop = true
    var content: ShopDisplay!

    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - SELECT IMAGE
    @IBAction private func selectImage(_ sender: Any) {
        pickingStart(.photoLibrary)
    }
    
    // MARK: - CHANGE SHOP OR DHISPLAY
    @IBAction private func changeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            isShop = true
            shopOrDisplaySwitch.isOn = true
        } else {
            isShop = false
            shopOrDisplaySwitch.isOn = false
        }
    }
    
    // MARK: - SAVE
    @IBAction private func save(_ sender: Any) {
        
        guard let name = name.text, let manager = managerName.text else { return }
        saveContent(name, manager)
    }
}
