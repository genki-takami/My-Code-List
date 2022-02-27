/*
 VoteOperationViewControllerの拡張
 */

import UIKit

extension VoteOperationViewController {
    
    /// UIをセットアップ
    func setupView() {
        
        votingTable.tableFooterView = UIView()
        
        voteEventTitle.text = vTitle
        voteEventExplain.text = vExplain
        
        choiseOption ? (multiselect.text = "複数選択可") : (multiselect.text = "単一選択")
    }
}
