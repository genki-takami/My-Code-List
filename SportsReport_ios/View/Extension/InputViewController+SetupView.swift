/*
 InputViewControllerの拡張
 */

import UIKit

extension InputViewController {
    
    /// UIのセットアップ
    func setupView() {
        
        injured.text = report.injured
        reporter.text = report.reporter
        date.date = report.date
        spot.text = report.spot
        part.text = report.part
        diagnosis.text = report.diagnosis
        cause.text = report.cause
        aftereffect.text = report.aftereffect
        
        /// 画像が未設定だったらクエスチョンマークにする
        if NSData(data: report.image).count != 0 {
            picture.image = UIImage(data: report.image)
        } else {
            picture.image = UIImage(systemName: "questionmark.square.dashed")
        }
        
        setDismissKeyboard()
    }
}
