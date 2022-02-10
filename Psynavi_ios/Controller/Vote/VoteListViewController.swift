/*
 投票リストを表示する
 */

import UIKit
import Firebase
import SVProgressHUD

class VoteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // 変数
    @IBOutlet weak var voteTable: UITableView!
    @IBOutlet weak var voteTitle: UILabel!
    var voteList: [[String: Any]] = []
    var resultList: [[String:Any]] = []
    var uid: String!
    var upgrade: Bool!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート・データソース
        voteTable.delegate = self
        voteTable.dataSource = self
        voteTable.tableFooterView = UIView()
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if upgrade {
            if let uid = self.uid {
                SVProgressHUD.show()
                Database.database().reference().child("festivals/\(uid)").getData { (error, snapshot) in
                    if let _ = error {
                        SVProgressHUD.showError(withStatus: "データの読み込みに失敗しました")
                    } else if snapshot.exists() {
                        // データあり(課金済み)
                        if let object = snapshot.value as? [String:AnyObject]{
                            let keys = [String](object.keys)
                            for key in keys {
                                let event = object[key] as! [String:Any]
                                // データセットを取得
                                if let dataset = event["dataset"] as? [String:Any]{
                                    let lists = dataset["lists"] as! [[String:String]]
                                    var choises: [String] = []
                                    for list in lists {
                                        choises.append(list["title"]!)
                                    }
                                    let voteObject: [String:Any] = [
                                        "name" : dataset["name"] as! String,
                                        "info" : dataset["info"] as! String,
                                        "lists" : choises,
                                        "choise" : dataset["choise"] as! Bool,
                                        "state" : (dataset["finish"] as! Bool) ? "終了" : "実施中"
                                    ]
                                    self.voteList.append(voteObject)
                                }
                                // 結果を取得
                                if let result = event["result"] as? [String:Any]{
                                    self.resultList.append(result)
                                } else {
                                    // まだ誰も投票していない
                                    self.resultList.append(["all":"Nobody vote"])
                                }
                            }
                        }
                        self.refresh()
                    } else {
                        // データなし(課金済み)
                        self.refresh()
                    }
                    SVProgressHUD.dismiss()
                }
            }
        } else {
            // データなし(非課金)
            self.refresh()
        }
    }
    
    // テーブルをリフレッシュする
    func refresh(){
        DispatchQueue.main.async {
            self.voteTable.reloadData()
            if self.voteList.isEmpty {
                self.voteTitle.text = "投票イベントなし"
            }
        }
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteList.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 60
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteListCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = voteList[indexPath.row]["name"] as? String ?? "NaN"
        let tag = cell.viewWithTag(2) as! UILabel
        tag.text = voteList[indexPath.row]["state"] as? String ?? "作成中"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if voteList[indexPath.row]["state"] as! String == "実施中" {
            performSegue(withIdentifier: "voteDetailSegue",sender: nil)
        } else {
            performSegue(withIdentifier: "voteResultSegue",sender: nil)
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.voteTable.indexPathForSelectedRow
        switch segue.identifier {
        case "voteDetailSegue":
            let voteForAnyViewController:VoteOperationViewController = segue.destination as! VoteOperationViewController
            voteForAnyViewController.vet = self.voteList[indexPath!.row]["name"] as? String ?? "NaN"
            voteForAnyViewController.vee = self.voteList[indexPath!.row]["info"] as? String ?? "NaN"
            voteForAnyViewController.choises = self.voteList[indexPath!.row]["lists"] as? [String] ?? []
            voteForAnyViewController.choiseOption = self.voteList[indexPath!.row]["choise"] as? Bool ?? false
            voteForAnyViewController.uid = self.uid
        case "voteResultSegue":
            let voteResultViewController:VoteResultViewController = segue.destination as! VoteResultViewController
            voteResultViewController.resultObject = self.resultList[indexPath!.row]
        default:
            break
        }
    }
}
