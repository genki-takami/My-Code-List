/*
 ホームタブの処理
 */

import UIKit

final class HomeTabViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var festivalList: UITableView!
    @IBOutlet weak var search: UISearchBar!
    var dataArray = [HomeTabCellData]()
    var filteringDataArray = [HomeTabCellData]()
    var nameList = [String]()
    var matchItems = [String]()
    var noneFlag = false
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        festivalList.delegate = self
        festivalList.dataSource = self
        
        setupView()
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FetchData.isListenerNil() ? fetchSnapshot() : updateStar()
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchCatalog()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewFromHomeSegue"{
            let mainVC = segue.destination as! MainViewController
            let indexPath = sender as! IndexPath
            /// 検索してヒットしたデータがあれば、そこから参照
            if filteringDataArray.count > 0 {
                mainVC.uuid = filteringDataArray[indexPath.row].uuid
            } else {
                mainVC.uuid = dataArray[indexPath.row].uuid
            }
        }
    }
    
    // MARK: - Refresh
    @IBAction private func refreshHome(_ sender: Any) {
        filteringDataArray = []
        noneFlag = false
        reloadTable()
    }
}
