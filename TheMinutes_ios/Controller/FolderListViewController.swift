/*
 議事録フォルダリストの処理
 */

import RealmSwift

final class FolderListViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var folderList: UITableView!
    var folders = [Folder]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        folderList.delegate = self
        folderList.dataSource = self
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// フォルダーを参照する
        folders.removeAll()
        let data = RealmTask.findAll(RealmModel.folder) as! Results<Folder>
        let sortedData = data.sorted(byKeyPath: "date", ascending: false)
        sortedData.forEach {
            folders.append($0)
       }
        reloadTable()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "folderAddSegue"{
            let folderAddVC = segue.destination as! FolderAddViewController
            /// 新規作成
            let newFolder = Folder()
            folderAddVC.folder = newFolder
        } else if segue.identifier == "minuteListSegue"{
            let minuteListVC = segue.destination as! MinuteListViewController
            /// フォルダーのIDと名前を渡す
            let indexPath = folderList.indexPathForSelectedRow
            minuteListVC.folderId = folders[indexPath!.row].id
            minuteListVC.titleName = folders[indexPath!.row].folderName
        }
    }
}

