/*
 投票の結果を表示する
 */

import UIKit

final class VoteResultViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var firstPoints: UILabel!
    @IBOutlet weak var secondTitle: UILabel!
    @IBOutlet weak var secondPoints: UILabel!
    @IBOutlet weak var thirdTitle: UILabel!
    @IBOutlet weak var thirdPoints: UILabel!
    var resultObject: [String:Any]!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        /// UIをセットアップ
        setupView(resultObject)
    }
}
