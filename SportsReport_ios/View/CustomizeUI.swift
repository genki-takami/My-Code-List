/*
 既存のクラスをカスタマイズ！
 */

import UIKit

// MARK: - 画面を一つ前に戻す処理(storyboard用)
final class DismissSegue: UIStoryboardSegue {
    override func perform() {
        self.source.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerの共通処理
extension UIViewController {
    
    /// キーボードを閉じるジェスチャー
    func setDismissKeyboard() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
