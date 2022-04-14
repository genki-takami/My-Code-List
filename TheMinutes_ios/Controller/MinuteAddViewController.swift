/*
 議事録ファイルの追加処理
 */

import RealmSwift

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
    var places = [Place]()
    var attendees = [Attendee]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        /// 登録データを参照する
        let placeData = RealmTask.findAll(RealmModel.place) as! Results<Place>
        placeData.filter("folderId == %@", minute.folderId).forEach {
            places.append($0)
        }
        let attendeeData = RealmTask.findAll(RealmModel.attendee) as! Results<Attendee>
        attendeeData.filter("folderId == %@", minute.folderId).forEach {
            attendees.append($0)
        }
    }
    
    // MARK: - 登録した会議場所を取得する
    @IBAction private func pickPlace(_ sender: Any) {
        
        if places.isEmpty {
            Modal.showError("登録された場所はありません！")
        } else {
            showPlaceList(with: places)
        }
    }
    
    // MARK: - 登録した人物名を取得する
    @IBAction private func pickAttendee(_ sender: Any) {
        
        if attendees.isEmpty {
            Modal.showError("登録された人物名はありません！")
        } else {
            showAttendeeList(with: attendees)
        }
    }
    
    // MARK: - SAVE
    @IBAction private func save(_ sender: Any) {
        saving()
    }
    
    // MARK: - CREATE PDF
    @IBAction private func createPDF(_ sender: Any) {
        
        let text = concatenateText()
        navigatePDF(text)
    }
    
    // MARK: - SHARE DATA
    @IBAction private func share(_ sender: UIButton) {
        
        let text = concatenateText()
        present(ShareData.modeText(text, view), animated: true, completion: nil)
    }
}
