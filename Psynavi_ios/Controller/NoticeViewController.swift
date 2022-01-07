/*
 お知らせタブの処理
 */

import UIKit
import RealmSwift
import Firebase
import SVProgressHUD

class NoticeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {

    // 変数
    @IBOutlet weak var noticeList: UITableView!
    let realm = try! Realm()
    var noticeData: [(name:String,noticeTitle:String?,date:Date?,noticeContent:String?,strDate:String?)] = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート・データソース
        noticeList.delegate = self
        noticeList.dataSource = self
        noticeList.tableFooterView = UIView()
        noticeList.refreshControl = UIRefreshControl()
        noticeList.refreshControl?.addTarget(self, action: #selector(refreshNotices), for: .valueChanged)
    }
    
    // データを更新
    @objc func refreshNotices(){
        self.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.noticeList.refreshControl?.endRefreshing()
        }
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        noticeData.removeAll()
        let allRealmData = realm.objects(RealmData.self)
        if allRealmData.count != 0{
            var taskCounter = allRealmData.count
            for rdata in allRealmData{
                // お気に入り登録されたコンテンツのお知らせデータを受信
                Firestore.firestore().collection(Const.ListNoticeID).document(rdata.id).getDocument{ (document, error) in
                    
                    SVProgressHUD.show()
                    // エラー判定
                    if let _ = error{
                        Analytics.logEvent("error_NoticeViewController_viewWillAppear", parameters: [AnalyticsParameterItemName:"お気に入りオブジェクトのお知らせデータの取得に失敗" as String])
                        SVProgressHUD.showError(withStatus: "お知らせデータの取得に失敗！")
                        return
                    }
                    
                    if document!.exists {
                        if let data = document!.data(){
                            let noticeArray: [String] = data["list"] as! [String]
                            for i in noticeArray{
                                let thisOne = data[i] as? [String : Any]
                                let timestamp: Timestamp! = thisOne!["date"] as? Timestamp
                                let dateValue = timestamp.dateValue()
                                let f = DateFormatter()
                                f.locale = Locale(identifier: "ja_JP")
                                f.dateStyle = .long
                                f.timeStyle = .short
                                let date = f.string(from: dateValue)
                                // データを形成する
                                let tuple:(name:String,noticeTitle:String?,date:Date?,noticeContent:String?,strDate:String?) = (
                                    name: rdata.festivalName,
                                    noticeTitle: thisOne!["noticeTitle"] as? String,
                                    date: dateValue,
                                    noticeContent: thisOne!["noticeContent"] as? String,
                                    strDate: date
                                )
                                self.noticeData.append(tuple)
                            }
                            taskCounter -= 1
                            if taskCounter == 0{
                                self.listSorting()
                            }
                        }
                    } else {
                        // すでに削除されている
                        taskCounter -= 1
                        if taskCounter == 0{
                            self.listSorting()
                        }
                    }
                }
            }
        } else {
            // お気に入りがなし
            self.noticeList.reloadData()
        }
    }
    
    // 並び替える
    func listSorting(){
        if self.noticeData.count >= 2{
            // 日付順に並び替え
            self.noticeData = self.noticeData.sorted(by: { (a,b) -> Bool in
                return a.date! > b.date!
            })
        }
        self.noticeList.reloadData()
        SVProgressHUD.dismiss()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeData.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さ
        tableView.rowHeight = 99
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeBarCell", for: indexPath)
       
        let festivalName = cell.viewWithTag(1) as! UILabel
        festivalName.text = noticeData[indexPath.row].name
        let noticeTitle = cell.viewWithTag(2) as! UILabel
        let mainSentence = noticeData[indexPath.row].noticeTitle
        noticeTitle.text = "件名：\(String(mainSentence!))"
        let noticeDate = cell.viewWithTag(3) as! UILabel
        noticeDate.text = noticeData[indexPath.row].strDate
        
        // セルのタップ検知
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    // セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer){
        tableView(self.noticeList, didSelectRowAt: sender.indexValue!)
    }
    
    // セルのタップ時の処理を返す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // お知らせ詳細ポップを表示する
        let noticePopupViewController = self.storyboard?.instantiateViewController(withIdentifier: "noticePopup") as! NoticePopupViewController
        noticePopupViewController.modalPresentationStyle = .custom
        noticePopupViewController.transitioningDelegate = self
        noticePopupViewController.fesName = self.noticeData[indexPath.row].name
        noticePopupViewController.noticeTitle = self.noticeData[indexPath.row].noticeTitle
        noticePopupViewController.noticeDate = self.noticeData[indexPath.row].strDate
        noticePopupViewController.noticeContent = self.noticeData[indexPath.row].noticeContent
        self.present(noticePopupViewController, animated: true, completion: nil)
    }
    
    // カスタムポップアップを返す
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
