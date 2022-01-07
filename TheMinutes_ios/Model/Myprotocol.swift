/*
 データをコントローラー間で渡す処理のためのプロトコル
 */

import UIKit

protocol DataReturn{
    // PlaceList >>> MinuteAdd
    func returnData(text: String)
}

protocol DataReturn2 {
    // AttendeeList >>> MinuteAdd
    func returnData2(text: String)
}
