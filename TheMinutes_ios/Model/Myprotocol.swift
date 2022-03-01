/*
 データをコントローラー間で渡す処理のためのプロトコル
 */

protocol DataReturn: AnyObject {
    // PlaceList >>> MinuteAdd
    func returnData(text: String)
}

protocol DataReturn2: AnyObject {
    // AttendeeList >>> MinuteAdd
    func returnData2(text: String)
}

protocol MinuteAddViewSubMethod: AnyObject {
    func saving()
    func concatenateText() -> String
    func showPlaceList()
    func showAttendeeList()
    func navigatePDF(_ text: String)
}
