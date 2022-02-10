/*
 画面を一つ前に戻す処理(storyboard用)
 */

import UIKit

class DismissSegue: UIStoryboardSegue {
    
    override func perform() {
        self.source.dismiss(animated: true, completion: nil)
    }
}
