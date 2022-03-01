/*
 PDFを作成するクラス
 */

import PDFKit

final class PDFViewController: UIViewController {
    
    // MARK: - Property
    private var data: Data!
    var reportText: String = ""
    var image: UIImage! = UIImage(named: "launchicon")
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// データを挿入
        data = PDF.create(reportText, image)
        
        /// 背後にPDFを表示する
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
        
        /// 共有モーダルを表示
        let activityVC = ShareData.modePDF(data)
        present(activityVC, animated: true, completion: nil)
    }
}
