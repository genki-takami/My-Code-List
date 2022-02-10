/*
 議事録ファイルの追加処理
 */

import UIKit

final class MinuteAddViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var headerTitle: UILabel!
    @IBOutlet private weak var meetingName: UITextField!
    @IBOutlet private weak var secretary: UITextField!
    @IBOutlet private weak var topic: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var attendee: UITextField!
    @IBOutlet private weak var meetingContents: UITextView!
    @IBOutlet private weak var decision: UITextView!
    @IBOutlet private weak var note: UITextView!
    var isNewObject: Bool!
    var minute: Minute!
    var isSaved = false
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingData()
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: - SET DATA
    private func settingData() {
        isNewObject ? (headerTitle.text = "議事録の追加") : (headerTitle.text = "議事録の編集")
        meetingName.text = minute.meetingName
        secretary.text = minute.secretary
        topic.text = minute.topic
        datePicker.date = minute.date
        place.text = minute.place
        attendee.text = minute.attendee
        meetingContents.text = minute.meetingContents
        decision.text = minute.decision
        note.text = minute.note
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
    
    // 保存
    func saving() {
        
        guard let name = meetingName.text else { return }
        
        if name.isEmpty {
            DisplayPop.error("会議名を記入してください")
            isSaved = false
        } else {
            let data: [String:Any] = [
                "meetingName": name,
                "secretary": secretary.text ?? "---",
                "topic": topic.text ?? "---",
                "date": datePicker.date,
                "place": place.text ?? "---",
                "attendee": attendee.text ?? "---",
                "meetingContents": meetingContents.text ?? "---",
                "decision": decision.text ?? "---",
                "note": note.text ?? "---",
            ]
            
            DataProcessing.add(minute, data, EditMode.modifyMinute, RealmModel.minute) { result in
                switch result {
                case .success(let text):
                    self.isSaved = true
                    DisplayPop.success(text)
                case .failure(let error):
                    self.isSaved = false
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - CREATE PDF
    @IBAction private func createPDF(_ sender: Any) {
        
        let text = concatenateText()
        text.isEmpty ? DisplayPop.error("処理中にエラーが起きました") : navigatePDF(text)
    }
    
    // MARK: - SHARE DATA
    @IBAction private func share(_ sender: UIButton) {
        
        let text = concatenateText()
        text.isEmpty ? DisplayPop.error("処理中にエラーが起きました") : present(ShareData.modeText(text), animated: true, completion: nil)
    }
}
