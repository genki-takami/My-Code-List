/*
 MinuteAddViewControllerの拡張
 */

extension MinuteAddViewController {
    
    /// UIのセットアップ
    func setupView() {
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
        
        setDismissKeyboard()
    }
}
