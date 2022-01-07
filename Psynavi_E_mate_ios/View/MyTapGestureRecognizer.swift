/*
 タップしたらインデックスを返す処理(tableViewやcollectionViewのセルで使用)
 */

import UIKit

class MyTapGestureRecognizer: UITapGestureRecognizer {

    // セルのインデックスを格納
    var indexValue: IndexPath?
}
