/*
 既存のクラスをカスタマイズ！
 */

import MapKit

// MARK: - 画面を一つ前に戻す処理(storyboard用)
final class DismissSegue: UIStoryboardSegue {
    override func perform() {
        self.source.dismiss(animated: true, completion: nil)
    }
}

// MARK: - タップしたらインデックスを返す処理(tableViewやcollectionViewのセルで使用)
final class MyTapGestureRecognizer: UITapGestureRecognizer {
    /// セルのインデックス
    var indexValue: IndexPath?
}

// MARK: - カスタムアノテーションのクラス
final class MapAnnotationSetting: MKPointAnnotation {
    /// マーカーピンの画像
    var pinImage: UIImage?
}

// MARK: - カスタムテキストフィールドのクラス
final class CustomTextField: UITextField {
    /// 下線用のUIView
    private let underline: UIView = UIView()

    override func layoutSubviews() {
        super.layoutSubviews()

        frame.size.height = 50
        borderStyle = .none
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 2.5)
        underline.backgroundColor = UIColor(red: 0.36, green: 0.61, blue: 0.93, alpha: 1.0)

        addSubview(underline)
        bringSubviewToFront(underline)
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
    
    /// タブバーに戻る遷移
    func backToTabbar(at index: Int) {
        let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        tabBer.modalPresentationStyle = .fullScreen
        tabBer.selectedIndex = index
        
        present(tabBer, animated: true, completion: nil)
    }
}

// MARK: - EditContent・EditNotice・EditEvent の継承元クラス
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
