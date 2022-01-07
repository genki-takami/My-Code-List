/*
 ホームタブの処理
 */

import UIKit
import Firebase
import RealmSwift
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // 変数
    @IBOutlet weak var festivalList: UITableView!
    @IBOutlet weak var search: UISearchBar!
    var dataArray: [FirebaseData] = [], filteringDataArray:[FirebaseData] = []
    var listener: ListenerRegistration!
    let realm = try! Realm()
    var allRealmData: Results<RealmData>!
    let db =  Firestore.firestore()
    var nameList: [String] = [], matchItems: [String] = []
    var noneFlag = false
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SVProgressHUDのセットアップ
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        // デリゲート・データソース
        festivalList.delegate = self
        search.delegate = self
        search.searchBarStyle = .minimal
        festivalList.dataSource = self
        festivalList.separatorStyle = .none
        festivalList.refreshControl = UIRefreshControl()
        festivalList.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        // カスタムセルの登録する
        festivalList.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // データを更新する
    @objc func refreshData(){
        listener = nil
        dataArray.removeAll()
        filteringDataArray.removeAll()
        matchItems.removeAll()
        noneFlag = false
        self.viewWillAppear(true)
        self.receiveCatalog()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            // 終了
            self.festivalList.refreshControl?.endRefreshing()
        }
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        if listener == nil {
            // リスナー未登録なら、登録してスナップショットを受信する
            let dataRef = db.collection(Const.FestivalPath)
            listener = dataRef.order(by: "timeStamp", descending: true).limit(to: 20).addSnapshotListener() { (querySnapshot, error) in
                if let _ = error {
                    Analytics.logEvent("error_HomeViewController_viewWillAppear", parameters: [AnalyticsParameterItemName: "スナップショットの取得失敗" as String])
                } else {
                    // 取得したdocumentをもとにfestivalDataを作成し、dataArrayの配列にする。
                    self.dataArray = querySnapshot!.documents.map { document in
                        return FirebaseData(document: document)
                    }
                    // tableViewの表示を更新する
                    self.festivalList.reloadData()
                }
            }
        } else {
            self.viewFilter()
        }
    }
    
    // セルのお気に入りボタンのステータス更新
    func viewFilter(){
        allRealmData = realm.objects(RealmData.self)
        if self.dataArray.count != 0{
            for i in self.dataArray{
                self.likeFilter(data: i, likes: allRealmData)
            }
        }
        if self.filteringDataArray.count != 0{
            for i in self.filteringDataArray{
                self.likeFilter(data: i, likes: allRealmData)
            }
        }
        // tableViewの表示を更新する
        self.festivalList.reloadData()
    }
    
    // お気に入りステータス変換
    func likeFilter(data: FirebaseData, likes: Results<RealmData>){
        if likes.count != 0{
            if let matchData = likes.first(where: { $0.id == data.uuid }){
                // お気に入りの場合
                data.isFavorite = matchData.isFavorite
            } else {
                // お気に入りでない場合
                data.isFavorite = false
            }
        } else {
            // お気に入りが１つも存在しない
            data.isFavorite = false
        }
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellNumber = 0
        // フィルターリストにオブジェクトがあるか検索機能での不一致判定がtrueの場合、その数を返す
        if filteringDataArray.count != 0 || self.noneFlag{
            cellNumber = filteringDataArray.count
        } else {
            cellNumber = dataArray.count
        }
        return cellNumber
    }

    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 160
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        // フィルターリストにオブジェクトがあるか検索機能での不一致判定がtrueの場合、その数を返す
        if filteringDataArray.count != 0 || self.noneFlag{
            cell.setFirebaseData(filteringDataArray[indexPath.row])
        } else {
            cell.setFirebaseData(dataArray[indexPath.row])
        }
        // セルのタップを検知
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        // お気に入り登録ボタン
        cell.favoriteButton.addTarget(self, action:#selector(pushFavoriteButton(_:forEvent:)), for: .touchUpInside)

        return cell
    }
    
    // festivalListをリフレッシュする
    @IBAction func refreshHome(_ sender: Any) {
        self.filteringDataArray = []
        self.noneFlag = false
        festivalList.reloadData()
    }
    
    // 検索機能の処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        
        if let text = searchBar.text{
            
            // 初期化
            self.filteringDataArray = []
            self.noneFlag = false
            
            // 無記入であればdataArrayを丸ごと格納
            if text.isEmpty{
                filteringDataArray = dataArray
                festivalList.reloadData()
                return
            }
            // スナップショットでフィルターする
            filteringDataArray = dataArray.filter{(data) -> Bool in
                return data.festivalName.lowercased().contains(text.lowercased())
            }
            
            
            if filteringDataArray.isEmpty{
                // スナップショットになかった場合
                
                // カタログでフィルターする
                matchItems = nameList.filter{ (item) -> Bool in
                    return item.lowercased().contains(text.lowercased())
                }
                
                if matchItems.count != 0{
                    var taskCounter = self.matchItems.count
                    for (index,i) in matchItems.enumerated(){
                        let query = db.collection(Const.FestivalPath).whereField("festivalName", isEqualTo: i).limit(to: 1)
                        query.getDocuments(){ (querySnapshot, error) in
                            // エラー判定
                            if let _ = error{
                                SVProgressHUD.showError(withStatus: "検索中にエラーが発生しました")
                                return
                            }
                            
                            if !(querySnapshot!.isEmpty){
                                let box: [FirebaseData] = querySnapshot!.documents.map { document in
                                    return FirebaseData(document: document)
                                }
                                // 取得したデータを格納
                                self.filteringDataArray += box
                                taskCounter -= 1
                                if index == self.matchItems.count - 1 && taskCounter == 0{
                                    self.festivalList.reloadData()
                                }
                            } else {
                                // すでに削除済み
                                taskCounter -= 1
                                if index == self.matchItems.count - 1 && taskCounter == 0{
                                    self.festivalList.reloadData()
                                    // 検索に引っかかったアイテムがすべて削除済みであった場合
                                    if self.filteringDataArray.isEmpty {
                                        self.noneFlag = true
                                        self.festivalList.reloadData()
                                        SVProgressHUD.showError(withStatus: "「\(text)」に一致するものはありませんでした。")
                                    }
                                }
                            }
                        }
                    }
                } else {
                    // firestoreにもない
                    self.noneFlag = true
                    SVProgressHUD.showError(withStatus: "「\(text)」に一致するものはありませんでした。")
                    festivalList.reloadData()
                }
            } else {
                // スナップショットにあった場合
                festivalList.reloadData()
            }
        }
    }
    
    // セルのお気に入りボタンのステータスを変更する
    @objc func pushFavoriteButton(_ sender: UIButton, forEvent event: UIEvent) {
        // タップされたセルのインデックスを求める
        let indexPath = festivalList.indexPathForRow(at: (event.allTouches?.first!.location(in: self.festivalList))!)

        var notFavoriteFlag = true
        allRealmData = realm.objects(RealmData.self)
        var dataId, dataFestivalName, dataFestivalDate, dataFestivalPlace: String!
        var favoriteState: Bool!
        
        if filteringDataArray.count > 0{
            // フィルター済みであった場合
            dataId = filteringDataArray[indexPath!.row].uuid
            dataFestivalName = filteringDataArray[indexPath!.row].festivalName
            dataFestivalDate = filteringDataArray[indexPath!.row].date
            dataFestivalPlace = filteringDataArray[indexPath!.row].place
            favoriteState = filteringDataArray[indexPath!.row].isFavorite
        } else {
            dataId = dataArray[indexPath!.row].uuid
            dataFestivalName = dataArray[indexPath!.row].festivalName
            dataFestivalDate = dataArray[indexPath!.row].date
            dataFestivalPlace = dataArray[indexPath!.row].place
            favoriteState = dataArray[indexPath!.row].isFavorite
        }
        if allRealmData.count != 0{
            // タップされたデータのuuidとお気に入りリストのidを照合
            if let data = allRealmData.first(where: { $0.id == dataId }){
                // お気に入りされていた場合
                do {
                    try realm.write {
                        self.realm.delete(data)
                    }
                } catch _ as NSError {
                    Analytics.logEvent("error_delete_HomeViewController_pushFavoriteButton", parameters: [AnalyticsParameterItemName:"お気に入り解除ができませんでした" as String])
                    SVProgressHUD.showError(withStatus: "お気に入り解除ができませんでした")
                }
                
                notFavoriteFlag = false
                favoriteState = false
                filteringDataArray.count > 0 ? (filteringDataArray[indexPath!.row].isFavorite = favoriteState) : (dataArray[indexPath!.row].isFavorite = favoriteState)
                sender.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        if notFavoriteFlag{
            // お気に入りに登録
            favoriteState = true
            let newRealmData = RealmData()
            do {
                try realm.write {
                    newRealmData.id = dataId
                    newRealmData.festivalName = dataFestivalName
                    newRealmData.festivalDate = dataFestivalDate
                    newRealmData.festivalPlace = dataFestivalPlace
                    newRealmData.isFavorite = favoriteState
                    self.realm.add(newRealmData,update: .modified)
                }
            } catch _ as NSError {
                Analytics.logEvent("error_register_HomeViewController_pushFavoriteButton", parameters: [AnalyticsParameterItemName:"お気に入り登録ができませんでした" as String])
                SVProgressHUD.showError(withStatus: "お気に入り登録ができませんでした")
            }
            
            filteringDataArray.count > 0 ? (filteringDataArray[indexPath!.row].isFavorite = favoriteState) : (dataArray[indexPath!.row].isFavorite = favoriteState)
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        self.festivalList.reloadData()
    }
    
    // セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer){
        tableView(self.festivalList, didSelectRowAt: sender.indexValue!)
    }
    
    // セルのタップ時の処理を返す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewFromHomeSegue",sender: indexPath)
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "viewFromHomeSegue"{
            let readingViewController:ReadingViewController = segue.destination as! ReadingViewController
            let indexPath = sender as! IndexPath
            filteringDataArray.count > 0 ? (readingViewController.uuid = filteringDataArray[indexPath.row].uuid) : (readingViewController.uuid = dataArray[indexPath.row].uuid)
        }
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // カタログリストを受信する
        self.receiveCatalog()
    }
    
    // カタログを受信
    func receiveCatalog(){
        nameList = []
        db.collection("catalog").document("nameList").getDocument{ (document, error) in
            if let _ = error{
                SVProgressHUD.showError(withStatus: "表示処理中にエラーが発生しました")
            } else {
                if document!.exists {
                    if let data = document!.data(){
                        self.nameList += data["list"] as! [String]
                        
                        let letterId = data["id"] as! String
                        if let _ = UserDefaults.standard.string(forKey: "newsletter\(letterId)") {
                            return
                        } else {
                            let message = data["newsletter"] as! String
                            let alertController: UIAlertController = UIAlertController(title: "お知らせ", message: message, preferredStyle: .alert)
                            let actionOk = UIAlertAction(title: "OK", style: .default){ action in
                                // 再度表示しない
                                UserDefaults.standard.setValue(letterId, forKey: "newsletter\(letterId)")
                            }
                            alertController.addAction(actionOk)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
