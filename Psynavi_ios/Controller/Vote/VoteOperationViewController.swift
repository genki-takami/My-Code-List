/*
 個別の投票処理
 */

import UIKit
import SVProgressHUD
import Firebase

final class VoteOperationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // 変数
    @IBOutlet weak var votingTable: UITableView!
    @IBOutlet weak var voteEventTitle: UILabel!
    @IBOutlet weak var voteEventExplain: UITextView!
    @IBOutlet weak var multiselect: UILabel!
    var choiseOption = false, uid = ""
    var vet, vee: String!
    var choises: [String] = [], selected: [String] = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート・データソース
        votingTable.delegate = self
        votingTable.dataSource = self
        votingTable.tableFooterView = UIView()
        // 表示処理
        voteEventTitle.text = vet
        voteEventExplain.text = vee
        choiseOption ? (multiselect.text = "複数選択可") : (multiselect.text = "単一選択")
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choises.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteChoiseCell", for: indexPath)
        
        let choise = cell.viewWithTag(1) as! UILabel
        choise.text = choises[indexPath.row]
        let selectBtn = cell.viewWithTag(2) as! UISwitch
        selectBtn.tag = indexPath.row
        selectBtn.addTarget(self, action: #selector(changeSwitch(_:forEvent:)), for: UIControl.Event.valueChanged)
        
        return cell
    }
    
    @objc func changeSwitch(_ sender: UISwitch, forEvent event: UIEvent) {
        // 選択した選択肢を配列に追加・除去する
        if sender.isOn {
            if choiseOption {
                // 複数選択可
                selected.append(choises[sender.tag])
            } else {
                // 単一選択
                if self.selected.isEmpty {
                    selected.append(choises[sender.tag])
                } else {
                    sender.isOn = false
                    SVProgressHUD.showError(withStatus: "この投票は複数選択できません！\n他の選択を解除して下さい")
                }
            }
        } else {
            let one = selected.firstIndex(of: choises[sender.tag])!
            selected.remove(at: one)
        }
    }
    
    // 投票する
    @IBAction func voting(_ sender: Any) {
       if let title = voteEventTitle.text {
            if UserDefaults.standard.bool(forKey: "rightOf\(self.uid)/\(title)"){
                // すでに投票済み
                SVProgressHUD.showError(withStatus: "ひとり１票です")
            } else {
                // まだ投票していない
                if selected.isEmpty {
                    SVProgressHUD.showError(withStatus: "１つ以上選択して下さい")
                } else {
                    let message = "１度投票したら、再度投票できません\n(ひとり１票)"
                    let alertController: UIAlertController = UIAlertController(title: "投票しますか？", message: message, preferredStyle: .alert)
                    let actionYes = UIAlertAction(title: "投票", style: .default){ action in
                        
                        SVProgressHUD.show()
                        let ref = Database.database().reference()
                        for (index, i) in self.selected.enumerated() {
                            let key = NSUUID().uuidString
                            let dateFormatter = DateFormatter()
                            dateFormatter.calendar = Calendar(identifier: .gregorian)
                            dateFormatter.locale = Locale(identifier: "ja_JP")
                            dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
                            dateFormatter.dateFormat = "yyyy/M/d/ H:mm:ss"
                            let dateString = dateFormatter.string(from: Date())
                            let vote = [
                                "timestamp" : dateString,
                                "vote" : i
                            ]
                            let childUpdates = ["/festivals/\(self.uid)/\(title)/votes/\(key)": vote]
                            ref.updateChildValues(childUpdates)
                            // 最終処理
                            if index == self.selected.count - 1 {
                                UserDefaults.standard.setValue(true, forKey: "rightOf\(self.uid)/\(title)")
                                SVProgressHUD.showSuccess(withStatus: "投票しました")
                            }
                        }
                    }
                    let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
                    alertController.addAction(actionYes)
                    alertController.addAction(actionCancel)
                    present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
