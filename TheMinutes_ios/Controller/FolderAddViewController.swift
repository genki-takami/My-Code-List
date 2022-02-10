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
        
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - ADD FOLDER
    @IBAction private func addFolder(_ sender: Any) {
        
        guard let name = folderNameTextField.text else { return }
        
        if name.isEmpty {
            DisplayPop.error("フォルダー名を記入してください")
        } else {
            
            folder.folderName = name
            DataProcessing.add(folder, [:], EditMode.add, RealmModel.folder) { result in
                switch result {
                case .success(let text):
                    self.dismiss(animated: true, completion: nil)
                    DisplayPop.success(text)
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
}
