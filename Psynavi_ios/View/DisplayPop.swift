/*
 SVProgressHUDの処理
 */

import Foundation
import SVProgressHUD

final class DisplayPop {
    
    private static var initializing = false
    
    static func success(_ text: String) {
        if initializing == false { setting() }
        SVProgressHUD.showSuccess(withStatus: text)
    }
    
    static func error(_ text: String) {
        if initializing == false { setting() }
        SVProgressHUD.showError(withStatus: text)
    }
    
    static func show() {
        if initializing == false { setting() }
        SVProgressHUD.show()
    }
    
    static func showMessage(_ message: String) {
        if initializing == false { setting() }
        SVProgressHUD.show(withStatus: message)
    }
    
    static func dismiss() {
        if initializing == false { setting() }
        SVProgressHUD.dismiss()
    }
    
    private static func setting() {
        // SVProgressHUDのセットアップ
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        initializing = true
    }
}
