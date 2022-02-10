/*
 レポートリストの表示処理
 */

import UIKit

final class ReportListViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var reportTable: UITableView!
    var reports: [Report] = []
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        reportTable.delegate = self
        reportTable.dataSource = self
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // レポートを参照する
        reports.removeAll()
        let data = DataProcessing.findAll().sorted(byKeyPath: "date", ascending: false)
        data.forEach {
            reports.append($0)
        }
        reportTable.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let inputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "edit" {
            let indexPath = reportTable.indexPathForSelectedRow
            inputViewController.report = reports[indexPath!.row]
        } else if segue.identifier == "add" {
            let newReport = Report()
            inputViewController.report = newReport
        }
    }
    
    // MARK: - ADD NEW
    @IBAction private func addNew(_ sender: Any) {
        performSegue(withIdentifier: "add", sender: nil)
    }
}
