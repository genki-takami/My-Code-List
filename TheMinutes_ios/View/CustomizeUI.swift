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

// MARK: - ロングタップしたらインデックスを返す
final class MyLongPressGestureRecognizer: UILongPressGestureRecognizer {
    // セルのインデックスを格納
    var indexValue: IndexPath?
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

// MARK: - MinureAdd の継承元クラス
class CreationUIViewController: UIViewController {
    
    /// 遷移元のライフサイクルメソッドを維持する
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
        }
        super.viewWillAppear(animated)
    }
    
    /// 遷移元のライフサイクルメソッドを維持する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    /// 遷移元のライフサイクルメソッドを維持する
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
}
