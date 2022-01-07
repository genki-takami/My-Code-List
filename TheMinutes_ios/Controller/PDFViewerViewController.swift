/*
 PDFを作成するクラス
 */

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {

    // 変数
    var minute: String = ""
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PDFを表示する
        let pdfView = PDFView()
        pdfView.frame = view.bounds
        pdfView.autoScales = true
        pdfView.backgroundColor = .lightGray
        pdfView.document = PDFDocument(data: createPDFData())
        pdfView.displaysPageBreaks = true
        view.addSubview(pdfView)
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let sharePDF = createPDFData()
        let activityItems = [sharePDF]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let excludedActivityTypes = [
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.print
        ]
        activityVC.excludedActivityTypes = excludedActivityTypes
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // pdfを作成
    func createPDFData() -> Data {
        
        // PDFのファイル名
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateString:String = formatter.string(from: Date())
        
        // メタデータフォーマット
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextCreator: "created by 「直感的」議事録",
            kCGPDFContextAuthor: "https://itunes.apple.com/us/app/%E7%9B%B4%E6%84%9F%E7%9A%84-%E8%AD%B0%E4%BA%8B%E9%8C%B2%E3%82%A2%E3%83%97%E3%83%AA/id1511551625?itsct=apps_box&itscg=30200",
            kCGPDFContextTitle: "議事録_\(dateString)作成"
        ] as [String: Any]
        
        // A4サイズにレンダリング
        let pageRect = CGRect(x: 0, y: 0, width: 2100, height: 2900)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        // 内容の入力
        let data = renderer.pdfData { (context) in
            
            // Start writing
            context.beginPage()
            
            // スタイル
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .natural
            paragraphStyle.lineBreakMode = .byWordWrapping
            // テキストデータ
            let attributedText = NSAttributedString(
                string: self.minute,
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: .regular)
                ]
            )
            // テキストを描写していく
            attributedText.draw(in: CGRect(x: 100, y: 150, width: pageRect.width - 200, height: pageRect.height - 300))
            
            // End Writing
        }
        
        return data
    }
}
