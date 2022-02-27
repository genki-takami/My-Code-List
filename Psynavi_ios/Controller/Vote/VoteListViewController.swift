/*
 投票リストを表示する
 */

import UIKit

final class VoteListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var voteTable: UITableView!
    @IBOutlet weak var voteTitle: UILabel!
    var resultList = [[String:Any]]()
    var voteList = [[String:Any]]()
    var uid: String!
    var upgrade: Bool!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        voteTable.delegate = self
        voteTable.dataSource = self
        
        setupView()
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 投票イベントデータを取得する
        fetchVoteData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = voteTable.indexPathForSelectedRow
        
        switch segue.identifier {
        case "voteDetailSegue":
            let voreOperationVC = segue.destination as! VoteOperationViewController
            voreOperationVC.vTitle = voteList[indexPath!.row]["name"] as? String ?? "NaN"
            voreOperationVC.vExplain = voteList[indexPath!.row]["info"] as? String ?? "NaN"
            voreOperationVC.choises = voteList[indexPath!.row]["lists"] as? [String] ?? []
            voreOperationVC.choiseOption = voteList[indexPath!.row]["choise"] as? Bool ?? false
            voreOperationVC.uid = uid
        case "voteResultSegue":
            let voteResultVC = segue.destination as! VoteResultViewController
            voteResultVC.resultObject = resultList[indexPath!.row]
        default:
            break
        }
    }
}
