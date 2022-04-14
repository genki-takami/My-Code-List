/*
 共有処理
 */

import UIKit

final class ShareData {
    
    /// 共有する項目
    private static let excludedActivityTypes = [
        UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter,
        UIActivity.ActivityType.message, UIActivity.ActivityType.saveToCameraRoll,
        UIActivity.ActivityType.print, UIActivity.ActivityType.markupAsPDF,
    ]
    
    /// - Parameter
    ///     - data:     The PDF Data
    ///     - view:     The view used for source view
    /// - Returns:  Modal activityviewController to share PDF
    static func modePDF(_ data: Data, _ view: UIView) -> UIActivityViewController {
        return createActivityVC(data, view)
    }
    
    /// - Parameter
    ///     - data:     The Text Data
    ///     - view:     The view used for source view
    /// - Returns:  Modal activityviewController to share txt data
    static func modeText(_ text: String, _ view: UIView) -> UIActivityViewController {
        return createActivityVC(text, view)
    }
    
    /// - Parameter
    ///     - item:     The Text Data or The PDF Data
    ///     - view:     The view used for source view
    /// - Returns:  Modal activityviewController
    private static func createActivityVC<T>(_ item: T, _ view: UIView) -> UIActivityViewController {
        
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController!.sourceView = view
            activityViewController.popoverPresentationController!.sourceRect = CGRect(x: view.bounds.size.width / 2.0, y: view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        }
        
        return activityViewController
    }
}
