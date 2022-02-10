/*
 ホームタブの処理
 */

import UIKit

final class HomeTabViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var festivalList: UITableView!
    @IBOutlet private weak var search: UISearchBar!
    var dataArray = [HomeTabCellData]()
    var filteringDataArray = [HomeTabCellData]()
    var nameList = [String]()
    var matchItems = [String]()
    var noneFlag = false
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - SETUP
    private func setupSearchBar() {
        search.delegate = self
        search.searchBarStyle = .minimal
    }
    
    private func setupTableView() {
        festivalList.delegate = self
        festivalList.dataSource = self
        festivalList.separatorStyle = .none
        festivalList.refreshControl = UIRefreshControl()
        festivalList.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        // カスタムセルの登録
        festivalList.register(UINib(nibName: "HomeTabListViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FetchData.isListenerNil() ? fetchData() : starCheck()
    }
    
    // 検索前に戻す
    @IBAction private func refreshHome(_ sender: Any) {
        filteringDataArray = []
        noneFlag = false
        festivalList.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewFromHomeSegue"{
            let mainVC = segue.destination as! MainViewController
            let indexPath = sender as! IndexPath
            // 検索ヒットがあれば、それから参照
            if filteringDataArray.count > 0 {
                mainVC.uuid = filteringDataArray[indexPath.row].uuid
            } else {
                mainVC.uuid = dataArray[indexPath.row].uuid
            }
        }
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // カタログを受信する
        receiveCatalog()
    }
}
