/*
 議事録ファイルの追加処理
 */

import UIKit

final class MinuteAddViewController: CreationUIViewController {

    // MARK: - Property
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var meetingName: UITextField!
    @IBOutlet weak var secretary: UITextField!
    @IBOutlet weak var topic: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var attendee: UITextField!
    @IBOutlet weak var meetingContents: UITextView!
    @IBOutlet weak var decision: UITextView!
    @IBOutlet weak var note: UITextView!
    var isNewObject: Bool!
    var minute: Minute!
    var isSaved = false
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBAction private func pickPlace(_ sender: Any) {
        showPlaceList()
    }
    
    @IBAction private func pickAttendee(_ sender: Any) {
        showAttendeeList()
    }
    
    // MARK: - SAVE
    @IBAction private func save(_ sender: Any) {
        
        saving()
        
        if isSaved {
            dismiss(animated: true, completion: nil)
        }
    }
    // MARK: - CREATE PDF
    @IBAction private func createPDF(_ sender: Any) {
        
        let text = concatenateText()
        text.isEmpty ? Modal.showError("処理中にエラーが起きました") : navigatePDF(text)
    }
    
    // MARK: - SHARE DATA
    @IBAction private func share(_ sender: UIButton) {
        
        let text = concatenateText()
        text.isEmpty ? Modal.showError("処理中にエラーが起きました") : present(ShareData.modeText(text), animated: true, completion: nil)
    }
}
