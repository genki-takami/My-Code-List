/*
 投票の結果を表示する
 */

import UIKit

class VoteResultViewController: UIViewController {

    // 変数
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var firstPoints: UILabel!
    @IBOutlet weak var secondTitle: UILabel!
    @IBOutlet weak var secondPoints: UILabel!
    @IBOutlet weak var thirdTitle: UILabel!
    @IBOutlet weak var thirdPoints: UILabel!
    var resultObject: [String:Any]!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // データを取得
        let allCount = resultObject.removeValue(forKey: "all") as! String
        titleLabel.text = "結果（\(allCount)）"
        // リセット
        firstTitle.text = "-----"
        firstPoints.text = "得票数：なし"
        secondTitle.text = "-----"
        secondPoints.text = "得票数：なし"
        thirdTitle.text = "-----"
        thirdPoints.text = "得票数：なし"
        if !resultObject.isEmpty {
            if resultObject.count == 1 {
                let key = [String](resultObject.keys)[0]
                firstTitle.text = "\(key)"
                firstPoints.text = "得票数：\(self.resultObject[key] as! Int)票"
            } else if resultObject.count > 1 {
                let sortedResult = resultObject.sorted{ $0.value as! Int > $1.value as! Int }
                let first = sortedResult[0]
                firstTitle.text = "\(first.key)"
                firstPoints.text = "得票数：\(first.value as! Int)票"
                let second = sortedResult[1]
                secondTitle.text = "\(second.key)"
                secondPoints.text = "得票数：\(second.value as! Int)票"
                if resultObject.count > 2 {
                    let third = sortedResult[2]
                    thirdTitle.text = "\(third.key)"
                    thirdPoints.text = "得票数：\(third.value as! Int)票"
                }
            }
        }
    }
}
