/*
 出席者と会議場所の追加処理
 */

import RealmSwift

final class ResisterAddViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var attendeeList: UITableView!
    @IBOutlet private weak var attendeeInput: UITextField!
    @IBOutlet weak var placeList: UITableView!
    @IBOutlet private weak var placeInput: UITextField!
    var places = [Place]()
    var attendees = [Attendee]()
    var folderId: String!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendeeList.dataSource = self
        attendeeList.delegate = self
        placeList.dataSource = self
        placeList.delegate = self
        
        setDismissKeyboard()
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// 登録場所データを参照
        places.removeAll()
        let place = RealmTask.findAll(RealmModel.place) as! Results<Place>
        place.filter("folderId == %@", folderId!).forEach {
            places.append($0)
        }
        placeList.reloadData()
        
        /// 登録参加者データを参照
        attendees.removeAll()
        let attendee = RealmTask.findAll(RealmModel.attendee) as! Results<Attendee>
        attendee.filter("folderId == %@", folderId!).forEach {
            attendees.append($0)
        }
        attendeeList.reloadData()
    }
    
    // MARK: - ADD ATTENDEE
    @IBAction func attendeeAdd(_ sender: Any) {
        
        guard let text = attendeeInput.text else { return }
        
        if text.isEmpty {
            Modal.showError("追加したい出席者の名前を入力してください")
        } else {
            let attendee = Attendee()
            attendee.attendeeName = text
            attendee.folderId = folderId
            
            RealmTask.add(attendee, [:], EditMode.add, RealmModel.attendee) { result in
                switch result {
                case .success(let text2):
                    Modal.showSuccess(text2)
                    self.attendeeInput.text = ""
                    self.attendees.append(attendee)
                    self.attendeeList.reloadData()
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
    
    // MARK: - ADD PLACE
    @IBAction func placeAdd(_ sender: Any) {
        
        guard let text = placeInput.text else { return }
        
        if text.isEmpty {
            Modal.showError("場所の名前を入力してください")
        } else {
            let place = Place()
            place.meetingPlace = text
            place.folderId = folderId
            
            RealmTask.add(place, [:], EditMode.add, RealmModel.place) { result in
                switch result {
                case .success(let text2):
                    Modal.showSuccess(text2)
                    self.placeInput.text = ""
                    self.places.append(place)
                    self.placeList.reloadData()
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
