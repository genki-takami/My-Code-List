/*
 データをコントローラー間で渡す処理のためのプロトコル
 */

import UIKit

protocol DataReturn: AnyObject {
    // EventImageCreateViewController >>> EventsEditViewController
    func returnData(imageData: UIImage, captionData: String)
}

protocol DataReturn2: AnyObject {
    // PinEditViewController >>> MapEditViewController
    func returnData2(titleData: String, subtitleData: String, imageData: String)
}

protocol DataReturn3: AnyObject {
    // URLViewController >>> CreateViewController
    func returnData3(t1: String, u1: String, t2: String, u2: String)
}
