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
    /// - Returns:  Modal activityviewController to share PDF
    static func modePDF(_ data: Data) -> UIActivityViewController {
        
        let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        return activityViewController
    }
    
    /// - Parameter
    ///     - data:     The Text Data
    /// - Returns:  Modal activityviewController to share txt data
    static func modeText(_ text: String) -> UIActivityViewController {
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        return activityViewController
    }
}
