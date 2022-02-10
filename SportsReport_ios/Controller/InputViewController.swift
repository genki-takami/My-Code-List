/*
 新規作成・編集の処理
 */

import UIKit

final class InputViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var injured: UITextField!
    @IBOutlet private weak var reporter: UITextField!
    @IBOutlet private weak var date: UIDatePicker!
    @IBOutlet private weak var spot: UITextField!
    @IBOutlet private weak var part: UITextField!
    @IBOutlet private weak var diagnosis: UITextField!
    @IBOutlet private weak var cause: UITextField!
    @IBOutlet private weak var aftereffect: UITextField!
    @IBOutlet weak var picture: UIImageView!
    private var isSaved = false
    var report: Report!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpData()
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - SETUPDATA
    private func setUpData() {
        injured.text = report.injured
        reporter.text = report.reporter
        date.date = report.date
        spot.text = report.spot
        part.text = report.part
        diagnosis.text = report.diagnosis
        cause.text = report.cause
        aftereffect.text = report.aftereffect
        // 画像が未設定だったらクエスチョンマークにする
        if NSData(data: report.image).count != 0 {
            picture.image = UIImage(data: report.image)
        } else {
            picture.image = UIImage(systemName: "questionmark.square.dashed")
        }
    }
    
    // MARK: - CAMERA
    @IBAction private func setImageByCamera(_ sender: Any) {
        pickingStart(.camera)
    }
    
    // MARK: - PHOTO
    @IBAction private func setImageFromLibrary(_ sender: Any) {
        pickingStart(.photoLibrary)
    }
    
    // MARK: - SAVE
    @IBAction private func save(_ sender: Any) {
        guard let injured = injured.text, let reporter = reporter.text else { return }
        
        if injured.isEmpty || reporter.isEmpty {
            DisplayPop.error("負傷者と報告者を記入してください")
            return
        }
        
        DisplayPop.show()
        
        let draft: [String : Any] = [
            "injured": injured,
            "reporter": reporter,
            "date": date.date,
            "spot": spot.text!,
            "part": part.text!,
            "diagnosis": diagnosis.text!,
            "cause": cause.text!,
            "aftereffect": aftereffect.text!,
            "picture": picture.image!.jpegData(compressionQuality: 0.75)!,
        ]
        
        DataProcessing.add(report, draft) { result in
            switch result {
            case .success(let text):
                DisplayPop.success(text)
                self.isSaved = true
            case .failure(let error):
                DisplayPop.error(error.localizedDescription)
                self.isSaved = false
            }
        }
    }
    
    // MARK: - SHARE
    @IBAction private func share(_ sender: Any) {
        making(true)
    }
    
    // MARK: - CREATEPDF
    @IBAction private func createPDF(_ sender: Any) {
        making(false)
    }
    
    // データの共有
    private func making(_ isShare: Bool) {
        // 保存していなかったら保存する
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
            // 共有処理
            let activityVC = ShareData.modeText(concatenatedText)
            present(activityVC, animated: true, completion: nil)
        } else {
            // PDFの作成
            let p0 = "　　　　　　　　ケガに関するレポート powerd by 外傷レポートapp\n\n"
            
            let pdfVC = PDFViewController()
            pdfVC.reportText = p0 + concatenatedText
            if let data = picture.image {
                pdfVC.image = data
            }
            
            showNavigation(pdfVC)
        }
    }
}
