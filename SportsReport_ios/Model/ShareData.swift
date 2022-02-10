/*
 共有処理
 */

import Foundation
import UIKit

final class ShareData {
    
    private static let excludedActivityTypes = [
        UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter,
        UIActivity.ActivityType.message, UIActivity.ActivityType.saveToCameraRoll,
        UIActivity.ActivityType.print, UIActivity.ActivityType.markupAsPDF,
    ]
    
    static func modePDF(_ data: Data) -> UIActivityViewController {
        
        let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        return activityViewController
    }
    
    static func modeText(_ text: String) -> UIActivityViewController {
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        return activityViewController
    }
}
