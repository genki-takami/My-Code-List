/*
 データをコントローラー間で渡す処理のためのプロトコル
 */

import UIKit

protocol DataReturn: AnyObject {
    // PlaceList >>> MinuteAdd
    func returnData(text: String)
}

protocol DataReturn2: AnyObject {
    // AttendeeList >>> MinuteAdd
    func returnData2(text: String)
}
