/*
 MinuteAddViewControllerの拡張
 */

import UIKit

extension MinuteAddViewController: MinuteAddViewSubMethod, UIViewControllerTransitioningDelegate {
    
    /// 保存
    func saving() {
        
        guard let name = meetingName.text else { return }
        
        if name.isEmpty {
            Modal.showError("会議名を記入してください")
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
            
            RealmTask.add(minute, data, EditMode.modifyMinute, RealmModel.minute) { result in
                switch result {
                case .success(let text):
                    self.isSaved = true
                    Modal.showSuccess(text)
                case .failure(let error):
                    self.isSaved = false
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
    
    /// 文字列を結合する
    func concatenateText() -> String {
        
        saving()
        
        if isSaved {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString:String = formatter.string(from: minute.date)
            
            let p1 = "【会議名】\n\(minute.meetingName)\n\n"
            let p2 = "【書記】\n\(minute.secretary)\n\n"
            let p3 = "【議題】\n\(minute.topic)\n\n"
            let p4 = "【日時】\n\(dateString)\n\n"
            let p5 = "【場所】\n\(minute.place)\n\n"
            let p6 = "【出席者】\n\(minute.attendee)\n\n"
            let p7 = "【会議内容】\n\(minute.meetingContents)\n\n"
            let p8 = "【決定事項】\n\(minute.decision)\n\n"
            let p9 = "【備考】\n\(self.minute.note)"
            
            return p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9
        } else {
            return ""
        }
    }
    
    /// 登録した会議場所を表示
    func showPlaceList() {
        let placeListViewVC = storyboard?
            .instantiateViewController(withIdentifier: "placeTable") as! PlaceListViewController
        placeListViewVC.modalPresentationStyle = .custom
        placeListViewVC.transitioningDelegate = self
        placeListViewVC.delegate = self
        placeListViewVC.folderId = minute.folderId
        present(placeListViewVC, animated: true, completion: nil)
    }
    
    /// 登録した出席者を表示
    func showAttendeeList() {
        let attendeeListViewVC = storyboard?
            .instantiateViewController(withIdentifier: "attendeeTable") as! AttendeeListViewController
        attendeeListViewVC.modalPresentationStyle = .custom
        attendeeListViewVC.transitioningDelegate = self
        attendeeListViewVC.delegate = self
        attendeeListViewVC.folderId = minute.folderId
        present(attendeeListViewVC, animated: true, completion: nil)
    }
    
    /// PDFを表示する
    func navigatePDF(_ text: String) {
        
        let pdfVC = PDFViewController()
        pdfVC.minute = text
        let navigationViewController = UINavigationController(rootViewController: pdfVC)
        
        present(navigationViewController, animated: true, completion: nil)
    }
    
    /// カスタムポップアップを表示
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MinuteAddViewController: DataReturn {
    /// 会議場所データを受け取る
    func returnData(text: String) {
        guard let placeText = place.text else { return }
        placeText.isEmpty ? (place.text = text) : (place.text = placeText + "、" + text)
    }
}

extension MinuteAddViewController: DataReturn2 {
    /// 出席者データを受け取る
    func returnData2(text: String) {
        guard let attendeeText = attendee.text else { return }
        attendeeText.isEmpty ? (attendee.text = text) : (attendee.text = attendeeText + "、" + text)
    }
}
