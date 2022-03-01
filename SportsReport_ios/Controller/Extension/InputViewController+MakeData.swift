/*
 InputViewControllerの拡張
 */

import Foundation

extension InputViewController {
    
    /// 共有データの構築
    func makeData(ofShare isShare: Bool) {
        
        /// 保存していなかったら保存処理
        if !isSaved {
            save(true)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString: String = formatter.string(from: report.date)
        
        let p1 = "【負傷者】\n\(report.injured)\n\n"
        let p2 = "【報告者】\n\(report.reporter)\n\n"
        let p3 = "【発生日時】\n\(dateString)\n\n"
        let p4 = "【場所】\n\(report.spot)\n\n"
        let p5 = "【負傷部位】\n\(report.part)\n\n"
        let p6 = "【医師による診断名】\n\(report.diagnosis)\n\n"
        let p7 = "【主な原因】\n\(report.cause)\n\n"
        let p8 = "【後遺症など】\n\(report.aftereffect)\n\n"
        let concatenatedText = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8
        
        if isShare {
            /// 共有処理
            let activityVC = ShareData.modeText(concatenatedText)
            present(activityVC, animated: true, completion: nil)
        } else {
            /// PDFの作成(わざとスペースを空けている)
            let reportTitle = "　　　　　　　　ケガに関するレポート powerd by 外傷レポートapp\n\n"
            
            let pdfVC = PDFViewController()
            /// テキストデータ
            pdfVC.reportText = reportTitle + concatenatedText
            /// 画像データ
            if let data = picture.image {
                pdfVC.image = data
            }
            
            showNavigation(pdfVC)
        }
    }
}
