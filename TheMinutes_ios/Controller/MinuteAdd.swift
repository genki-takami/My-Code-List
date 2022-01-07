/*
 議事録ファイルの追加処理
 */

import UIKit
import RealmSwift
import Accounts
import SVProgressHUD

class MinuteAdd: UIViewController, UIViewControllerTransitioningDelegate, DataReturn, DataReturn2 {

    // 準備
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
    let realm = try! Realm()
    var minute:MinuteListModel!
    var connectedText: String = ""
    var didSaving = true
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNewObject ? (self.headerTitle.text = "議事録ファイルの追加") : (self.headerTitle.text = "議事録ファイルの編集")
        self.meetingName.text = minute.meetingName
        self.secretary.text = minute.secretary
        self.topic.text = minute.topic
        self.datePicker.date = minute.date
        self.place.text = minute.place
        self.attendee.text = minute.attendee
        self.meetingContents.text = minute.meetingContents
        self.decision.text = minute.decision
        self.note.text = minute.note
        
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 遷移元のライフサイクルメソッドを維持する
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
        }
        super.viewWillAppear(animated)
    }
    
    // 遷移元のライフサイクルメソッドを維持する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    // 遷移元のライフサイクルメソッドを維持する
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    // 登録した会議場所を表示
    @IBAction func pickPlace(_ sender: Any) {
        let placeList = self.storyboard?.instantiateViewController(withIdentifier: "placeTable") as! PlaceList
        placeList.modalPresentationStyle = .custom
        placeList.transitioningDelegate = self
        placeList.delegate = self
        self.present(placeList, animated: true, completion: nil)
    }
    
    // 会議場所データを受け取る
    func returnData(text: String) {
        if let pt = place.text{
            if pt.isEmpty{
                self.place.text = text
            } else {
                self.place.text = pt + "、" + text
            }
        }
    }
    
    // 登録した出席者を表示
    @IBAction func pickAttendee(_ sender: Any) {
        let attendeeList = self.storyboard?.instantiateViewController(withIdentifier: "attendeeTable") as! AttendeeList
        attendeeList.modalPresentationStyle = .custom
        attendeeList.transitioningDelegate = self
        attendeeList.delegate = self
        self.present(attendeeList, animated: true, completion: nil)
    }
    
    // 出席者データを受け取る
    func returnData2(text: String) {
        if let at = attendee.text{
            if at.isEmpty{
                self.attendee.text = text
            } else {
                self.attendee.text = at + "、" + text
            }
        }
    }
    
    // ポップアップをカスタマイズ
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // 保存してリストに戻る
    @IBAction func save(_ sender: Any) {
        saving()
        if didSaving{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // データベースに保存
    func saving(){
        if let name = self.meetingName.text{
            
            if name.isEmpty{
                SVProgressHUD.showError(withStatus: "会議名を記入してください")
                self.didSaving = false
                return
            }
            
            do {
                try realm.write {
                    self.minute.meetingName = name
                    self.minute.secretary = self.secretary.text ?? "---"
                    self.minute.topic = self.topic.text ?? "---"
                    self.minute.date = self.datePicker.date
                    self.minute.place = self.place.text ?? "---"
                    self.minute.attendee = self.attendee.text ?? "---"
                    self.minute.meetingContents = self.meetingContents.text ?? "---"
                    self.minute.decision = self.decision.text ?? "---"
                    self.minute.note = self.note.text ?? "---"
                    self.realm.add(self.minute, update: .modified)
                }
                self.didSaving = true
                SVProgressHUD.showSuccess(withStatus: "保存作業完了")
            } catch _ as NSError {
                SVProgressHUD.showError(withStatus: "保存に失敗！再度お試しください")
                self.didSaving = false
                return
            }
        }
    }
    
    // PDFを作成
    @IBAction func createPDF(_ sender: Any) {
        createText()
        if self.connectedText.isEmpty{
            SVProgressHUD.showError(withStatus: "処理中にエラーが起きました")
            return
        } else {
            let pdfViewerViewController = PDFViewerViewController()
            pdfViewerViewController.minute = self.connectedText
            let navigationViewController = UINavigationController(rootViewController: pdfViewerViewController)
            present(navigationViewController, animated: true, completion: nil)
        }
    }
    
    // 結合テキストを作る
    func createText(){
        saving()
        if didSaving{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString:String = formatter.string(from: self.minute.date)
            let p1 = "【会議名】\n\(self.minute.meetingName)\n\n"
            let p2 = "【書記】\n\(self.minute.secretary)\n\n"
            let p3 = "【議題】\n\(self.minute.topic)\n\n"
            let p4 = "【日時】\n\(dateString)\n\n"
            let p5 = "【場所】\n\(self.minute.place)\n\n"
            let p6 = "【出席者】\n\(self.minute.attendee)\n\n"
            let p7 = "【会議内容】\n\(self.minute.meetingContents)\n\n"
            let p8 = "【決定事項】\n\(self.minute.decision)\n\n"
            let p9 = "【備考】\n\(self.minute.note)"
            self.connectedText = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9
        }
    }
    
    // 共有する
    @IBAction func share(_ sender: UIButton) {
        createText()
        if self.connectedText.isEmpty{
            SVProgressHUD.showError(withStatus: "処理中にエラーが起きました")
            return
        } else {
            let shareText = self.connectedText
            let activityItems = [shareText]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            let excludedActivityTypes = [
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.message,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.markupAsPDF
            ]
            activityVC.excludedActivityTypes = excludedActivityTypes
            // UIActivityViewControllerを表示
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
