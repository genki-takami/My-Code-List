/*
 既存のクラスをカスタマイズ！
 */

import UIKit
import MapKit

// MARK: - 画面を一つ前に戻す処理(storyboard用)
final class DismissSegue: UIStoryboardSegue {
    
    override func perform() {
        self.source.dismiss(animated: true, completion: nil)
    }
}

// MARK: - タップしたらインデックスを返す処理(tableViewやcollectionViewのセルで使用)
final class MyTapGestureRecognizer: UITapGestureRecognizer {

    // セルのインデックス
    var indexValue: IndexPath?
}

// MARK: - カスタムアノテーションのクラス
final class MapAnnotationSetting: MKPointAnnotation {
    
    // マーカーピンの画像
    var pinImage: UIImage?
}

// MARK: - カスタムテキストフィールドのクラス
final class CustomTextField: UITextField {

    // 下線用のUIView
    private let underline: UIView = UIView()

    override func layoutSubviews() {
        super.layoutSubviews()

        frame.size.height = 50
        borderStyle = .none
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 2.5)
        underline.backgroundColor = UIColor(red:0.36, green:0.61, blue:0.93, alpha:1.0)

        addSubview(underline)
        bringSubviewToFront(underline)
    }
}
