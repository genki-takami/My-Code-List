/*
 投票の結果を表示する
 */

import UIKit

final class VoteResultViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstTitle: UILabel!
    @IBOutlet private weak var firstPoints: UILabel!
    @IBOutlet private weak var secondTitle: UILabel!
    @IBOutlet private weak var secondPoints: UILabel!
    @IBOutlet private weak var thirdTitle: UILabel!
    @IBOutlet private weak var thirdPoints: UILabel!
    var resultObject: [String:Any]!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        // まず全体結果を取得
        let allCount = resultObject.removeValue(forKey: "all") as! String
        titleLabel.text = "結果（\(allCount)）"
        
        // UIリセット
        makeDefault()
        
        if !resultObject.isEmpty {
            if resultObject.count == 1 {
                // 得票数：１
                let key = [String](resultObject.keys)[0]
                firstTitle.text = "\(key)"
                firstPoints.text = "得票数：\(resultObject[key] as! Int)票"
            } else if resultObject.count > 1 {
                // 投票第１位
                let sortedResult = resultObject.sorted{ $0.value as! Int > $1.value as! Int }
                let first = sortedResult[0]
                firstTitle.text = "\(first.key)"
                firstPoints.text = "得票数：\(first.value as! Int)票"
                // 投票第２位
                let second = sortedResult[1]
                secondTitle.text = "\(second.key)"
                secondPoints.text = "得票数：\(second.value as! Int)票"
                
                if resultObject.count > 2 {
                    // 投票第３位
                    let third = sortedResult[2]
                    thirdTitle.text = "\(third.key)"
                    thirdPoints.text = "得票数：\(third.value as! Int)票"
                }
            }
        }
    }
    
    // デフォルト状態にする
    private func makeDefault() {
        firstTitle.text = "-----"
        firstPoints.text = "得票数：なし"
        secondTitle.text = "-----"
        secondPoints.text = "得票数：なし"
        thirdTitle.text = "-----"
        thirdPoints.text = "得票数：なし"
    }
}
