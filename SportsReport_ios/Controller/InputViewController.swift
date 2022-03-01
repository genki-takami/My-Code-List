/*
 新規作成・編集の処理
 */

import UIKit

final class InputViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var injured: UITextField!
    @IBOutlet weak var reporter: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var spot: UITextField!
    @IBOutlet weak var part: UITextField!
    @IBOutlet weak var diagnosis: UITextField!
    @IBOutlet weak var cause: UITextField!
    @IBOutlet weak var aftereffect: UITextField!
    @IBOutlet weak var picture: UIImageView!
    var isSaved = false
    var report: Report!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - CAMERA
    @IBAction private func setImageByCamera(_ sender: Any) {
        pickingStart(.camera)
    }
    
    // MARK: - PHOTO
    @IBAction private func setImageFromLibrary(_ sender: Any) {
        pickingStart(.photoLibrary)
    }
    
    // MARK: - SAVE
    @IBAction func save(_ sender: Any) {
        
        guard let injured = injured.text, let reporter = reporter.text else { return }
        
        if injured.isEmpty || reporter.isEmpty {
            Modal.showError("負傷者と報告者を記入してください")
            return
        }
        
        Modal.show()
        
        let draft: [String:Any] = [
            "injured": injured,
            "reporter": reporter,
            "date": date.date,
            "spot": spot.text!,
            "part": part.text!,
            "diagnosis": diagnosis.text!,
            "cause": cause.text!,
            "aftereffect": aftereffect.text!,
            "picture": picture.image!.jpegData(compressionQuality: 0.75)!,
        ]
        
        RealmTask.add(report, draft) { result in
            switch result {
            case .success(let text):
                Modal.showSuccess(text)
                self.isSaved = true
            case .failure(let error):
                Modal.showError(String(describing: error))
                self.isSaved = false
            }
        }
    }
    
    // MARK: - SHARE
    @IBAction private func share(_ sender: Any) {
        makeData(ofShare: true)
    }
    
    // MARK: - CREATEPDF
    @IBAction private func createPDF(_ sender: Any) {
        makeData(ofShare: false)
    }
}
