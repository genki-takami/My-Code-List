/*
 個別の投票処理
 */

import UIKit

final class VoteOperationViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var votingTable: UITableView!
    @IBOutlet weak var voteEventTitle: UILabel!
    @IBOutlet weak var voteEventExplain: UITextView!
    @IBOutlet weak var multiselect: UILabel!
    var choiseOption = false, uid = ""
    var vTitle, vExplain: String!
    var choises = [String]()
    var selected = [String]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        votingTable.delegate = self
        votingTable.dataSource = self
        
        setupView()
    }
    
    // MARK: - VOTE
    @IBAction private func voting(_ sender: Any) {
        
        guard let title = voteEventTitle.text else { return }
        
        if UserDefaultsTask.getPersonalData("rightOf\(uid)/\(title)") {
            /// すでに投票済み
            Modal.showError("ひとり１票です")
        } else {
            /// まだ投票していない
            if selected.isEmpty {
                /// 未選択
                Modal.showError("１つ以上選択して下さい")
            } else {
                /// 投票準備OK
                self.vote(for: title)
            }
        }
    }
}
