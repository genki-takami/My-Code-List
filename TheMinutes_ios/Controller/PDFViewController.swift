/*
 PDFを作成するクラス
 */

import UIKit
import PDFKit

final class PDFViewController: UIViewController {

    // MARK: - Property
    var minute: String = ""
    private var data: Data!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // データを挿入
        data = PDF.create(minute)
        
        // 背後にPDFを表示する
        let pdfView = PDFView()
        pdfView.frame = view.bounds
        pdfView.autoScales = true
        pdfView.backgroundColor = .lightGray
        pdfView.document = PDFDocument(data: data)
        pdfView.displaysPageBreaks = true
        view.addSubview(pdfView)
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 共有モーダルを表示
        let activityVC = ShareData.modePDF(data)
        present(activityVC, animated: true, completion: nil)
    }
}
