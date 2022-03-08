/*
 MinuteAddViewControllerの拡張
 */

import UIKit

extension MinuteAddViewController: MinuteAddViewSubMethod {
    
    /// 保存
    func saving() {
        
        guard let name = meetingName.text else { return }
        
        if name.isEmpty {
            Modal.showError("会議名を記入してください")
        } else {
            let data: [String:Any] = [
                "meetingName": name,
                "secretary": secretary.text!,
                "topic": topic.text!,
                "date": datePicker.date,
                "place": place.text!,
                "attendee": attendee.text!,
                "meetingContents": meetingContents.text!,
                "decision": decision.text!,
                "note": note.text!,
            ]
            
            RealmTask.add(minute, data, EditMode.modifyMinute, RealmModel.minute) { result in
                switch result {
                case .success(let text):
                    Modal.showSuccess(text)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
    
    /// 文字列を結合する
    func concatenateText() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: datePicker.date)
        
        let p1 = "【会議名】\n\(meetingName.text!)\n\n"
        let p2 = "【書記】\n\(secretary.text!)\n\n"
        let p3 = "【議題】\n\(topic.text!)\n\n"
        let p4 = "【日時】\n\(dateString)\n\n"
        let p5 = "【場所】\n\(place.text!)\n\n"
        let p6 = "【出席者】\n\(attendee.text!)\n\n"
        let p7 = "【会議内容】\n\(meetingContents.text!)\n\n"
        let p8 = "【決定事項】\n\(decision.text!)\n\n"
        let p9 = "【備考】\n\(note.text!)"
        
        return p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9
    }
    
    /// PDFを表示する
    func navigatePDF(_ text: String) {
        
        let pdfVC = PDFViewController()
        pdfVC.minute = text
        let navigationViewController = UINavigationController(rootViewController: pdfVC)
        
        present(navigationViewController, animated: true, completion: nil)
    }
}

extension MinuteAddViewController: UIViewControllerTransitioningDelegate {
    
    /// 登録した会議場所を表示
    func showPlaceList(with array: [Place]) {
        let placeListViewVC = storyboard?
            .instantiateViewController(withIdentifier: "placeTable") as! PlaceListViewController
        placeListViewVC.modalPresentationStyle = .custom
        placeListViewVC.transitioningDelegate = self
        placeListViewVC.delegate = self
        placeListViewVC.places = array
        present(placeListViewVC, animated: true, completion: nil)
    }
    
    /// 登録した出席者を表示
    func showAttendeeList(with array: [Attendee]) {
        let attendeeListViewVC = storyboard?
            .instantiateViewController(withIdentifier: "attendeeTable") as! AttendeeListViewController
        attendeeListViewVC.modalPresentationStyle = .custom
        attendeeListViewVC.transitioningDelegate = self
        attendeeListViewVC.delegate = self
        attendeeListViewVC.attendees = array
        present(attendeeListViewVC, animated: true, completion: nil)
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
