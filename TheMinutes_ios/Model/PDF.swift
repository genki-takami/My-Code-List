/*
 PDFの作成処理
 */

import PDFKit

final class PDF {
    
    /// - Parameter :
    ///     - text:             Entered text data
    /// - Returns :     PDF data
    static func create(_ text: String) -> Data {
        
        /// PDFのファイル名の一部
        let formatter = DateFormatter()
        let locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: locale)
        let dateString:String = formatter.string(from: Date())
        
        /// メタデータフォーマット
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextCreator: "created by 「直感的」議事録",
            kCGPDFContextAuthor: "https://itunes.apple.com/us/app/%E7%9B%B4%E6%84%9F%E7%9A%84-%E8%AD%B0%E4%BA%8B%E9%8C%B2%E3%82%A2%E3%83%97%E3%83%AA/id1511551625?itsct=apps_box&itscg=30200",
            kCGPDFContextTitle: "議事録_\(dateString)作成",
        ] as [String: Any]
        
        /// A4サイズにレンダリング
        let pageRect = CGRect(x: 0,
                              y: 0,
                              width: 2100,
                              height: 2900)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        /// 内容の入力
        let data = renderer.pdfData { context in
            
            context.beginPage()
            
            /// スタイル
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .natural
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            /// フォント
            let font = UIFont.systemFont(ofSize: 45, weight: .regular)
            
            /// 属性
            let attributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: font,
            ]
            
            /// テキストデータ
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            
            /// 画像エリア入力
            let imageRect = CGRect(x: 100,
                                   y: 150,
                                   width: pageRect.width - 200,
                                   height: pageRect.height - 300)
            
            /// テキストを描写していく
            attributedText.draw(in: imageRect)
        }
        
        return data
    }
}
