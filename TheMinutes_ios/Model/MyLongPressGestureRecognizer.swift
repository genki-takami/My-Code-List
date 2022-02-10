/*
 ロングタップしたらインデックスを返す処理(tableViewのセルで使用)
 */

import UIKit

final class MyLongPressGestureRecognizer: UILongPressGestureRecognizer {

    // セルのインデックスを格納
    var indexValue: IndexPath?
}
