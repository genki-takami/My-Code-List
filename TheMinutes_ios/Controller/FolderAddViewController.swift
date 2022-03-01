/*
 議事録フォルダの追加処理
 */

import UIKit

final class FolderAddViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var folderNameTextField: UITextField!
    var folder : Folder!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissKeyboard()
    }
    
    // MARK: - ADD FOLDER
    @IBAction private func addFolder(_ sender: Any) {
        
        guard let name = folderNameTextField.text else { return }
        
        if name.isEmpty {
            Modal.showError("フォルダー名を記入してください")
        } else {
            
            folder.folderName = name
            
            RealmTask.add(folder, [:], EditMode.add, RealmModel.folder) { result in
                switch result {
                case .success(let text):
                    self.dismiss(animated: true, completion: nil)
                    Modal.showSuccess(text)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
