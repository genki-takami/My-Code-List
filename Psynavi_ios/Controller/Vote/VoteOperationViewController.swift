/*
 個別の投票処理
 */

import UIKit

final class VoteOperationViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var votingTable: UITableView!
    @IBOutlet private weak var voteEventTitle: UILabel!
    @IBOutlet private weak var voteEventExplain: UITextView!
    @IBOutlet private weak var multiselect: UILabel!
    var choiseOption = false, uid = ""
    var vTitle, vExplain: String!
    var choises = [String]()
    var selected = [String]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpVoteData()
    }
    
    // MARK: - SET-UP
    private func setUpVoteData() {
        // 選択肢リスト
        votingTable.delegate = self
        votingTable.dataSource = self
        votingTable.tableFooterView = UIView()
        // 投票イベントの題目と説明
        voteEventTitle.text = vTitle
        voteEventExplain.text = vExplain
        // 選択方法
        choiseOption ? (multiselect.text = "複数選択可") : (multiselect.text = "単一選択")
    }
    
    // MARK: - VOTE
    @IBAction private func voting(_ sender: Any) {
        
       if let title = voteEventTitle.text {
        
            if DataProcessing.getPersonalData("rightOf\(uid)/\(title)") {
                // すでに投票済み
                DisplayPop.error("ひとり１票です")
            } else {
                // まだ投票していない
                if selected.isEmpty {
                    DisplayPop.error("１つ以上選択して下さい")
                } else {
                    // 投票準備OK
                    self.voteFor(title)
                }
            }
        }
    }
}
