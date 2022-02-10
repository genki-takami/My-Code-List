/*
 公開オブジェクトの表示処理
 */

import UIKit
import Firebase
import FirebaseUI

final class MainViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var festivalName: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var place: UILabel!
    @IBOutlet private weak var slogan: UILabel!
    @IBOutlet private weak var info: UILabel!
    @IBOutlet private weak var linkText1: UILabel!
    @IBOutlet private weak var linkText2: UILabel!
    @IBOutlet private weak var accountName: UILabel!
    @IBOutlet weak var commentName: UILabel!
    @IBOutlet private weak var commentText: UITextView!
    var uuid, url1, url2, mapFileUrl: String!
    var latitude, longitude: Double!
    let db = Firestore.firestore(), storePath = Firestore.firestore().collection(PathName.FestivalPath)
    var shopArray: [[String : Any]] = [], displayArray: [[String : Any]] = []
    var eventArray: [[String : Any]] = [], commentArray: [[String:Any]] = []
    var data, databaseProperty: [String : Any]!
    var noticeArray: [(noticeTitle:String?, date:Date?, noticeContent:String?, strDate:String?)] = []
    var loadingFlag = true, upgrade = false
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(refrefhing), for: .valueChanged)
        
        setUpCommentName()
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - JUMP TO WEBSITE 1
    @IBAction func goToWebsite1(_ sender: Any) {
        guard let jumpLink1 = url1 else { return }
        showBrowser(jumpLink1)
    }
    
    // MARK: - JUMP TO WEBSITE 2
    @IBAction func goToWebsite2(_ sender: Any) {
        guard let jumpLink2 = self.url2 else { return }
        showBrowser(jumpLink2)
    }
    
    // コメントを送る
    @IBAction func sendComment(_ sender: Any) {
        
        if let cmt = commentText.text, let cmn = commentName.text {
            
            if cmt.isEmpty {
                DisplayPop.error("コメントがありません！")
                return
            }
            
            let message = "内容：\(cmt.prefix(10))・・・"
            let alertController: UIAlertController = UIAlertController(title: "送信しますか？", message: message, preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "はい、送信", style: .default) { action in
                
                SVProgressHUD.show()
                
                let doc: [String: Any] = [
                    NSUUID().uuidString: [
                        "sender" :  cmn,
                        "comment" : cmt,
                        "timestamp" : Timestamp(date: Date())
                    ]
                ]
                self.db.collection(PathName.ListCommentID).document(self.uuid).setData(doc, merge: true){ err in
                    if let _ = err {
                        Analytics.logEvent("error_ReadingViewController_sendComment", parameters: [AnalyticsParameterItemName:"コメントの送信失敗" as String])
                        SVProgressHUD.showError(withStatus: "コメントの送信に失敗")
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ self.getDocComments() }
                        SVProgressHUD.showSuccess(withStatus: "コメントを送信しました！")
                    }
                }
            }
            let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alertController.addAction(actionYes)
            alertController.addAction(actionCancel)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        
        if loadingFlag {
            SVProgressHUD.show()
            // テキストデータを表示
            self.storePath.document(self.uuid).getDocument{ (document, error) in
                
                if let _ = error{
                    Analytics.logEvent("error_ReadingViewController_viewDidLoad", parameters: [AnalyticsParameterItemName:"公開オブジェクトのデータ取得に失敗" as String])
                    SVProgressHUD.showError(withStatus: "データが正しく読み込まれませんでした")
                    let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    tabBer.modalPresentationStyle = .fullScreen
                    tabBer.selectedIndex = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){ self.present(tabBer, animated: true, completion: nil) }
                } else {
                    if document!.exists {
                        if let data = document!.data(){
                            self.festivalName.text = data["festivalName"] as? String
                            self.date.text = data["date"] as? String
                            self.place.text = data["school"] as? String
                            self.slogan.text = data["slogan"] as? String
                            self.accountName.text = "created by \(data["owner"] as! String)"
                            self.info.text = data["info"] as? String
                            let linkArray: [String:String] = data["link"] as! [String:String]
                            self.linkText1.text = linkArray["title1"]!
                            self.url1 = linkArray["url1"]!
                            self.linkText2.text = linkArray["title2"]!
                            self.url2 = linkArray["url2"]!
                            self.latitude = data["latitude"] as? Double
                            self.longitude = data["longitude"] as? Double
                            self.upgrade = data["upgrade"] as? Bool ?? false
                            self.databaseProperty = data["database"] as? [String:Any]
                            self.mapFileUrl = data["mapFileLink"] as? String ?? ""
                            
                            // 画像データを表示
                            let db = Storage.storage().reference()
                            if self.databaseProperty["icon"] != nil {
                                self.iconImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                self.iconImage.sd_setImage(with: db.child(self.databaseProperty["icon"] as! String))
                            }
                            if self.databaseProperty["background"] != nil {
                                self.backgroundImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                self.backgroundImage.sd_setImage(with: db.child(self.databaseProperty["background"] as! String))
                            }
                            
                            // コメント
                            self.getDocComments()
                            
                            // ショップと展示
                            if self.databaseProperty["shop"] as! Int > 0 || self.databaseProperty["display"] as! Int > 0 {
                                self.db.collection(PathName.ListContentsID).document(self.uuid).getDocument { (document, error) in
                                    if let _ = error{
                                        Analytics.logEvent("error_s_d_ReadingViewController_viewDidAppear", parameters: [AnalyticsParameterItemName:"コンテンツのドキュメントの取得に失敗" as String])
                                        SVProgressHUD.showError(withStatus: "一部のデータが読み込まれませんでした")
                                    } else {
                                        if document!.exists {
                                            let id = document!.documentID
                                            if let data = document!.data(){
                                                let contentArray: [String] = data["list"] as! [String]
                                                for i in contentArray{
                                                    let thisOne = data[i] as! [String : Any]
                                                    let isShop = thisOne["switchFlag"] as! Bool
                                                    let dic = [
                                                        "id": id,
                                                        "name": thisOne["name"] as Any,
                                                        "date": thisOne["date"] as Any,
                                                        "place": thisOne["place"] as Any,
                                                        "manager": thisOne["manager"] as Any,
                                                        "managerInfo": thisOne["managerInfo"] as Any,
                                                        "tag": thisOne["tag"] as Any,
                                                        "info": thisOne["info"] as Any,
                                                        "video": thisOne.keys.contains("video") ? thisOne["video"] as Any : false
                                                    ] as [String : Any]
                                                    isShop ? self.shopArray.append(dic) : self.displayArray.append(dic)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // イベント
                            if self.databaseProperty["event"] as! Int > 0 {
                                self.db.collection(PathName.ListEventsID).document(self.uuid).getDocument { (document, error) in
                                    if let _ = error{
                                        Analytics.logEvent("error_event_ReadingViewController_viewDidAppear", parameters: [AnalyticsParameterItemName:"イベントのドキュメントの取得に失敗" as String])
                                        SVProgressHUD.showError(withStatus: "一部のデータが読み込まれませんでした")
                                    } else {
                                        if document!.exists {
                                            let id = document!.documentID
                                            if let data = document!.data(){
                                                let eventArray: [String] = data["list"] as! [String]
                                                for i in eventArray{
                                                    let thisOne = data[i] as! [String : Any]
                                                    let dic = [
                                                        "id": id,
                                                        "eventTitle": thisOne["eventTitle"] as Any,
                                                        "eventDate": thisOne["eventDate"] as Any,
                                                        "caption": thisOne["caption"] as Any,
                                                        "imageCaptions": thisOne["imageCaptions"] as Any,
                                                        "video": thisOne.keys.contains("video") ? thisOne["video"] as Any : false
                                                    ] as [String : Any]
                                                    self.eventArray.append(dic)
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                            // お知らせ
                            if self.databaseProperty["notice"] as! Int > 0 {
                                self.db.collection(PathName.ListNoticeID).document(self.uuid).getDocument { (document, error) in
                                    if let _ = error{
                                        Analytics.logEvent("error_notice_ReadingViewController_viewDidAppear", parameters: [AnalyticsParameterItemName:"お知らせのドキュメントの取得に失敗" as String])
                                        SVProgressHUD.showError(withStatus: "一部のデータが読み込まれませんでした")
                                    } else {
                                        if document!.exists {
                                            if let data = document!.data(){
                                                let noticeArray: [String] = data["list"] as! [String]
                                                for i in noticeArray{
                                                    let thisOne = data[i] as! [String : Any]
                                                    let dateValue = (thisOne["date"] as! Timestamp).dateValue()
                                                    let f = DateFormatter()
                                                    f.locale = Locale(identifier: "ja_JP")
                                                    f.dateStyle = .long
                                                    f.timeStyle = .short
                                                    let date = f.string(from: dateValue)
                                                    let tuple:(noticeTitle:String?,date:Date?,noticeContent:String?,strDate:String?) = (
                                                        noticeTitle: thisOne["noticeTitle"] as? String,
                                                        date: dateValue,
                                                        noticeContent: thisOne["noticeContent"] as? String,
                                                        strDate: date
                                                    )
                                                    self.noticeArray.append(tuple)
                                                }
                                                // 並び替える
                                                if self.noticeArray.count >= 2{
                                                    self.noticeArray = self.noticeArray.sorted(by: { (a,b) -> Bool in
                                                        return a.date! > b.date!
                                                    })
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            //マップ
                            if self.databaseProperty["marker"] as! Int > 0 {
                                self.db.collection(PathName.ListMapID).document(self.uuid).getDocument { (document, error) in
                                    if let _ = error{
                                        Analytics.logEvent("error_map_ReadingViewController_viewDidAppear", parameters: [AnalyticsParameterItemName:"マップのドキュメントの取得に失敗" as String])
                                        SVProgressHUD.showError(withStatus: "一部のデータが読み込まれませんでした")
                                    } else {
                                        if document!.exists {
                                            if let data = document!.data(){
                                                self.data = data
                                            }
                                        }
                                    }
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                SVProgressHUD.dismiss()
                                self.loadingFlag = false
                            }
                        }
                    } else {
                        // ドキュメントが存在しない場合
                        SVProgressHUD.showError(withStatus: "このコンテンツはすでに削除されています")
                        let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                        tabBer.modalPresentationStyle = .fullScreen
                        tabBer.selectedIndex = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ self.present(tabBer, animated: true, completion: nil) }
                    }
                }
            }
        }
        super.viewDidAppear(animated)
    }
    
    // コメントデータを受信する
    func getDocComments(){
        self.db.collection(PathName.ListCommentID).document(self.uuid).getDocument{ (document, error) in
            if let _ = error{
                Analytics.logEvent("error_getcommentlist_ReadingViewController_viewDidAppear", parameters: [AnalyticsParameterItemName:"コメントのドキュメントの取得に失敗" as String])
                SVProgressHUD.showError(withStatus: "一部のデータが読み込まれませんでした")
            } else {
                if document!.exists {
                    if let data = document!.data(){
                        self.commentArray.removeAll()
                        let keys = [String](data.keys)
                        for i in keys {
                            var oneComment = data[i] as! [String:Any]
                            oneComment["timestamp"] = (oneComment["timestamp"] as! Timestamp).dateValue()
                            self.commentArray.append(oneComment)
                        }
                        // 並び替える
                        self.commentArray = self.commentArray.sorted(by: { (a,b) -> Bool in
                            return a["timestamp"] as! Date > b["timestamp"] as! Date
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "lookShopSegue":
            let shopListVC = segue.destination as! ShopListViewController
            shopListVC.dataArray = self.shopArray
        case "lookDisplaySegue":
            let displayListVC = segue.destination as! DisplayListViewController
            displayListVC.dataArray = self.displayArray
        case "lookEventSegue":
            let eventListVC = segue.destination as! EventListViewController
            eventListVC.dataArray = self.eventArray
        case "lookMapSegue":
            let mapVC = segue.destination as! MapViewController
            mapVC.latitude = self.latitude
            mapVC.longitude = self.longitude
            mapVC.data = self.data
            mapVC.mapFileUrl = self.mapFileUrl
        case "lookNoticeSegue":
            let noticeListVC = segue.destination as! NoticeListViewController
            noticeListVC.dataArray = self.noticeArray
        case "toCommentListView":
            let commentListVC = segue.destination as! CommentListViewController
            commentListVC.dataArray = self.commentArray
        case "voteListSegue":
            let voteListVC = segue.destination as! VoteListViewController
            voteListVC.uid = self.uuid
            voteListVC.upgrade = self.upgrade
        default:
            break
        }
    }
}
