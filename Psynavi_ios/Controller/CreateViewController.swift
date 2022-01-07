/*
 作成・更新・公開・アカウント削除の処理
 */

import UIKit
import RealmSwift
import Firebase
import FirebaseUI
import SVProgressHUD

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DataReturn3 {

    // 変数
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var slogan: UITextField!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var accountName: UILabel!
    var isNewObject, upgrade: Bool!
    var mailAdress, password: String!
    var title1 = "", url1 = "", title2 = "", url2 = ""
    let realm = try! Realm()
    var saveData: SaveData!
    var successCount: Float = 0.1
    var contentImage: [String] = [], eventImage: [String] = []
    var alertFinish = false
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期値の表示or読み込み
        if !isNewObject {
            self.name.text = self.saveData.festivalName
            self.date.text = self.saveData.date
            self.school.text = self.saveData.school
            self.slogan.text = self.saveData.slogan
            self.info.text = self.saveData.info
            self.title1 = self.saveData.title1
            self.url1 = self.saveData.url1
            self.title2 = self.saveData.title2
            self.url2 = self.saveData.url2
            // 画像データを表示
            if !self.saveData.icon.isEmpty {
                icon.sd_imageIndicator = SDWebImageActivityIndicator.gray
                icon.sd_setImage(with: Storage.storage().reference().child(self.saveData.icon))
            }
            if !self.saveData.background.isEmpty {
                background.sd_imageIndicator = SDWebImageActivityIndicator.gray
                background.sd_setImage(with: Storage.storage().reference().child(self.saveData.background))
            }
            // オプション機能のUUID
            UserDefaults.standard.setValue(self.upgrade!, forKey: self.saveData.uuid)
        } else {
            // オプション機能のUUID
            self.upgrade = false
            UserDefaults.standard.setValue(false, forKey: self.saveData.uuid)
        }
        // ディスプレイネームの表示
        if let user = Auth.auth().currentUser{
            self.accountName.text = String(user.displayName!)
        }
        // プログレスバーの縦幅を10倍にする
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 重要情報をアラート
        if !self.alertFinish {
            let message = "＜新規作成の場合＞\nすべての情報を追加・編集できます。\n＜ログインの場合＞\nショップ/展示およびお知らせ、イベントの情報は新規追加のみになります。編集をする場合、Webブラウザにて「PsyなびStudio」をご利用ください。"
            let alertController: UIAlertController = UIAlertController(title: "重要", message: message, preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Let's start!", style: .default){ action in
                self.alertFinish = true
            }
            alertController.addAction(actionYes)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // アイコンのライブラリピッカー
    @IBAction func selectIconImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.modalPresentationStyle = .fullScreen
            pickerController.sourceType = .photoLibrary
            pickerController.title = "icon"
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // 背景のライブラリピッカー
    @IBAction func selectBackgroundImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.modalPresentationStyle = .fullScreen
            pickerController.sourceType = .photoLibrary
            pickerController.title = "background"
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // 選択したイメージを表示してピッカーを閉じる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let info = info[.originalImage] {
            // 選択された画像を設置する
            switch picker.title {
            case "icon":
                self.icon.image = info as? UIImage
            case "background":
                self.background.image = info as? UIImage
            default:
                break
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    // ピッカーのキャンセルボタンが押された時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier {
        case "settingLinkSegue":
            let urlViewController:URLViewController = segue.destination as! URLViewController
            urlViewController.receiveT1 = self.title1; urlViewController.receiveU1 = self.url1
            urlViewController.receiveT2 = self.title2; urlViewController.receiveU2 = self.url2
            urlViewController.delegate = self
        case "listSegue":
            let contentsTableViewController:ContentsTableViewController = segue.destination as! ContentsTableViewController
            contentsTableViewController.mailAdress = self.mailAdress
            contentsTableViewController.password = self.password
        case "createNoticeSegue":
            let noticeTableViewController:NoticeTableViewController = segue.destination as! NoticeTableViewController
            noticeTableViewController.mailAdress = self.mailAdress
            noticeTableViewController.password = self.password
        case "createEventSegue":
            let eventsTableViewController:EventsTableViewController = segue.destination as! EventsTableViewController
            eventsTableViewController.mailAdress = self.mailAdress
            eventsTableViewController.password = self.password
        case "createMapSegue":
            let mapEditViewController:MapEditViewController = segue.destination as! MapEditViewController
            mapEditViewController.mailAdress = self.mailAdress
            mapEditViewController.password = self.password
            if let data = realm.objects(MapDB.self).first(where: { $0.mailAdress == self.mailAdress && $0.password == self.password }) {
                mapEditViewController.festivalData = data
            } else {
                mapEditViewController.downloadLat = self.saveData.latitude
                mapEditViewController.downloadLon = self.saveData.longitude
                mapEditViewController.downloadableMarkers = self.saveData.marker
                mapEditViewController.uuid = self.saveData.uuid
            }
        case "voteOptionSegue":
            let voteOptionViewController:VoteOptionViewController = segue.destination as! VoteOptionViewController
            voteOptionViewController.upgrade = self.upgrade
            voteOptionViewController.uuid = self.saveData.uuid
        default:
            break
        }
    }
    
    // URLデータを受け取る
    func returnData3(t1: String, u1: String, t2: String, u2: String) {
        self.title1 = t1; self.url1 = u1; self.title2 = t2; self.url2 = u2
    }
    
    // ログアウト
    @IBAction func logout(_ sender: Any) {
        let alertController: UIAlertController = UIAlertController(title: "ログアウトしますか？", message: "タブ画面に戻ります", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "はい", style: .destructive){ action in
            // データを削除してからログアウト
            self.deleteRealmDatabase()
            self.signout(1)
        }
        let actionCancel = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // メインデータを保存する
    func savingData() -> Bool{
        if let nameOne = name.text{
            
            if nameOne.isEmpty{
                SVProgressHUD.showError(withStatus: "文化祭名を記入してください！")
                return false
            }
            
            if NSData(data: (self.icon.image?.jpegData(compressionQuality: 0.75))!).count == 0 || NSData(data: (self.background.image?.jpegData(compressionQuality: 0.75))!).count == 0{
                SVProgressHUD.showError(withStatus: "アイコン画像と背景画像を選択してください")
                return false
            }
            
            // アカウント作成履歴を作る
            if var accountList = UserDefaults.standard.stringArray(forKey: "accountList"){
                if accountList.first(where: { $0 == (self.accountName.text ?? "NO-NAME") }) == nil {
                    accountList.append(self.accountName.text ?? "NO-NAME")
                    UserDefaults.standard.setValue(accountList, forKey: "accountList")
                }
            } else {
                let initList: [String] = [self.accountName.text ?? "NO-NAME"]
                UserDefaults.standard.setValue(initList, forKey: "accountList")
            }
            
            self.saveData.festivalName = nameOne
            self.saveData.date = self.initializingText(self.date.text!)
            self.saveData.school = self.initializingText(self.school.text!)
            self.saveData.slogan = self.initializingText(self.slogan.text!)
            self.saveData.info = self.initializingText(self.info.text!)
            self.saveData.iconImage = (self.icon.image?.jpegData(compressionQuality: 0.75))!
            self.saveData.backgroundImage = (self.background.image?.jpegData(compressionQuality: 0.75))!
            self.saveData.title1 = self.title1
            self.saveData.url1 = self.url1
            self.saveData.title2 = self.title2
            self.saveData.url2 = self.url2
            
            return true
        } else {
            SVProgressHUD.showError(withStatus: "文化祭名を記入してください！")
            return false
        }
    }
    
    // テキストを初期化する
    func initializingText(_ text: String) -> String {
        if text.isEmpty {
            return "NaN"
        } else {
            return text
        }
    }
    
    // Firebaseにアップロードする
    func pushFirebase(){
        
        // 各データベースからこのオブジェクトのコンポーネントを持ってくる
        let contents = realm.objects(ContentsDB.self).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        let notices = realm.objects(NoticeDB.self).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        let events = realm.objects(EventsDB.self).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        let mapData = realm.objects(MapDB.self).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'").first ?? MapDB()
        if mapData.id == "init" {
            mapData.latitude = self.saveData.latitude
            mapData.longitude = self.saveData.longitude
        }
        
        // ドキュメントデータのパスとイメージデータのパス
        let firestore = Firestore.firestore()
        let db1 = firestore.collection(Const.DraftPath).document(self.saveData.uuid)
        let db2 = firestore.collection(Const.ListContentsID).document(self.saveData.uuid)
        let db3 = firestore.collection(Const.ListEventsID).document(self.saveData.uuid)
        let db4 = firestore.collection(Const.ListNoticeID).document(self.saveData.uuid)
        let db5 = firestore.collection(Const.ListMapID).document(self.saveData.uuid)
        let batch = firestore.batch()
        let imgdb = Storage.storage().reference().child(self.saveData.uuid)
        
        // メタデータ設定
        let storageMetadata = StorageMetadata()
        storageMetadata.contentType = "image/jpeg"
        
        self.progressView.setProgress(successCount, animated: true)// 10%
                
        // データベースプロパティのカウント
        var sc = self.saveData.shop, dc = self.saveData.display, ec = self.saveData.event, nc = self.saveData.notice, mc = self.saveData.marker
        var ci = self.contentImage, ei = self.eventImage
        // コンテンツデータ
        var contentsData: [String: Any] = [:]
        var contentList: [String] = []
        if !contents.isEmpty{
            for content in contents{
                let contentId = NSUUID().uuidString
                contentList.append(contentId)
                let data: [String: Any] = [
                    "switchFlag" : content.switchFlag,
                    "name" : content.name,
                    "manager" : content.manager,
                    "date" : content.date,
                    "place" : content.place,
                    "tag" : content.tag,
                    "info" : content.info,
                    "managerInfo" : content.managerInfo
                ]
                contentsData[contentId] = data
                content.switchFlag ? (sc += 1) : (dc += 1)
                ci.append("\(self.saveData.uuid)/\(Const.ContentImagePath)/\(content.name).jpg")
            }
            if self.isNewObject {
                contentsData["list"] = contentList
            }
        }
        // イベントデータ
        var eventsData: [String: Any] = [:]
        var eventList: [String] = []
        if !events.isEmpty{
            for event in events{
                // キャプションの配列を作成
                var captionList: [String] = []
                for n in event.imageCaptions{
                    captionList.append(n)
                    ei.append("\(self.saveData.uuid)/\(Const.EventImagePath)/\(event.eventTitle)/\(n.prefix(10)).jpg")
                }
                let eventId = NSUUID().uuidString
                eventList.append(eventId)
                let data: [String: Any] = [
                    "eventTitle" : event.eventTitle,
                    "eventDate" : event.eventDate,
                    "caption" : event.caption,
                    "imageCaptions" : captionList
                ]
                eventsData[eventId] = data
                ec += 1
            }
            if self.isNewObject {
                eventsData["list"] = eventList
            }
        }
        // お知らせデータ
        var noticesData: [String: Any] = [:]
        var noticeList: [String] = []
        if !notices.isEmpty{
            for notice in notices{
                let noticeId = NSUUID().uuidString
                noticeList.append(noticeId)
                let data: [String: Any] = [
                    "noticeTitle" : notice.noticeTitle,
                    "noticeContent" : notice.noticeContent,
                    "date" : Timestamp(date: notice.date)
                ]
                noticesData[noticeId] = data
                nc += 1
            }
            if self.isNewObject {
                noticesData["list"] = noticeList
            }
        }
        // マップデータ
        var annotationData: [String: Any] = [:]
        if !mapData.annotations.isEmpty{
            var pinList: [String] = []
            for pin in mapData.annotations{
                let pinId = NSUUID().uuidString
                pinList.append(pinId)
                let data: [String: Any] = [
                    "title" : pin.title,
                    "subtitle" : pin.subtitle,
                    "pinImage" : pin.pinImage,
                    "latitude" : pin.latitude,
                    "longitude" : pin.longitude
                ]
                annotationData[pinId] = data
                mc += 1
            }
            annotationData["list"] = pinList
        }
        // ドラフトデータ
        let mainData: [String: Any] = [
            "owner" :  self.accountName.text ?? "NO-NAME",
            "festivalName" : self.saveData.festivalName,
            "date" : self.saveData.date,
            "school" : self.saveData.school,
            "slogan" : self.saveData.slogan,
            "info" : self.saveData.info,
            "latitude" : mapData.latitude,
            "longitude" : mapData.longitude,
            "link" : [
                "title1" : self.saveData.title1,
                "url1" : self.saveData.url1,
                "title2" : self.saveData.title2,
                "url2" : self.saveData.url2
            ],
            "database" : [
                "shop": sc,
                "display": dc,
                "contentImage": ci,
                "event": ec,
                "marker": mc,
                "notice": nc,
                "eventImage": ei,
                "icon" : self.saveData.uuid + "/" + Const.FestivalIconImagePath + ".jpg",
                "background" : self.saveData.uuid + "/" + Const.FestivalBackgroundImagePath + ".jpg"
            ],
            "upgrade" : UserDefaults.standard.bool(forKey: self.saveData.uuid)
        ]
        
        // バッチ処理
        if !contentsData.isEmpty {
            batch.setData(contentsData, forDocument: db2, merge: true)
            if !self.isNewObject {
                batch.updateData(["list": FieldValue.arrayUnion(contentList)], forDocument: db2)
            }
        }
        if !eventsData.isEmpty {
            batch.setData(eventsData, forDocument: db3, merge: true)
            if !self.isNewObject {
                batch.updateData(["list": FieldValue.arrayUnion(eventList)], forDocument: db3)
            }
        }
        if !noticesData.isEmpty {
            batch.setData(noticesData, forDocument: db4, merge: true)
            if !self.isNewObject {
                batch.updateData(["list": FieldValue.arrayUnion(noticeList)], forDocument: db4)
            }
        }
        if !annotationData.isEmpty {
            batch.setData(annotationData, forDocument: db5)
        }
        batch.setData(mainData, forDocument: db1, merge: true)
        
        batch.commit() { error in
            if let _ = error {
                SVProgressHUD.showError(withStatus: "保存に失敗しました")
                self.progressView.setProgress(0.0, animated: true)
                return
            } else {
                self.stepBar()// 30%
                
                // アイコン画像
                imgdb.child(Const.FestivalIconImagePath + ".jpg").putData(self.saveData.iconImage, metadata: storageMetadata) { (metadata, error) in
                    if let _ = error {
                        Analytics.logEvent("error_icon_CreateViewController_pushFirebase", parameters: [AnalyticsParameterItemName:"アイコン画像のアップロード失敗" as String])
                        SVProgressHUD.showError(withStatus: "保存に失敗しました")
                        self.progressView.setProgress(0.0, animated: true)
                        return
                    } else {
                        self.successCount += 0.1
                        self.progressView.setProgress(self.successCount, animated: true)// 40%
                        
                        // 背景画像
                        imgdb.child(Const.FestivalBackgroundImagePath + ".jpg").putData(self.saveData.backgroundImage, metadata: storageMetadata) { (metadata, error) in
                            if let _ = error {
                                Analytics.logEvent("error_back_CreateViewController_pushFirebase", parameters: [AnalyticsParameterItemName:"背景画像のアップロード失敗" as String])
                                SVProgressHUD.showError(withStatus: "保存に失敗しました")
                                self.progressView.setProgress(0.0, animated: true)
                                return
                            } else {
                                self.successCount += 0.1
                                self.progressView.setProgress(self.successCount, animated: true)// 50%
                                
                                // コンテンツ画像
                                if !contentsData.isEmpty{
                                    var taskCounter = contents.count
                                    for i in contents{
                                        imgdb.child(Const.ContentImagePath).child(i.name + ".jpg").putData(i.image, metadata: storageMetadata) { (metadata, error) in
                                            if let _ = error {
                                                Analytics.logEvent("error_contentimage_CreateViewController_pushFirebase", parameters: [AnalyticsParameterItemName:"コンテンツ背景画像のアップロード失敗" as String])
                                                SVProgressHUD.showError(withStatus: "一部の画像の保存に失敗しました")
                                                self.progressView.setProgress(0.0, animated: true)
                                                return
                                            } else {
                                                taskCounter -= 1
                                                if taskCounter == 0 { self.stepBar() }// 70%
                                            }
                                        }
                                    } // コンテンツなし 70%
                                } else { self.stepBar() }
                                
                                // イベント画像
                                if !eventsData.isEmpty{
                                    var taskCounter2 = events.count
                                    var taskCounter3 = 0
                                    for j in events{
                                        // キャプションの配列を作成
                                        var captionList: [String] = []
                                        for n in j.imageCaptions{
                                            captionList.append(n)
                                        }
                                        taskCounter2 -= 1
                                        taskCounter3 += j.images.count// 画像の数だけタスクを追加していく
                                        if !j.images.isEmpty{
                                            for (index,k) in j.images.enumerated(){
                                                imgdb.child(Const.EventImagePath).child(j.eventTitle).child(captionList[index].prefix(10) + ".jpg").putData(k, metadata: storageMetadata) { (metadata, error) in
                                                    if let _ = error {
                                                        Analytics.logEvent("error_eventimage_CreateViewController_pushFirebase", parameters: [AnalyticsParameterItemName:"イベント画像のアップロード失敗" as String])
                                                        SVProgressHUD.showError(withStatus: "一部の画像の保存に失敗しました")
                                                        self.progressView.setProgress(0.0, animated: true)
                                                        return
                                                    } else {
                                                        taskCounter3 -= 1
                                                        if taskCounter2 == 0 && taskCounter3 == 0 { self.stepBar() }// 90%
                                                    }
                                                }
                                            } // イベントデータはあるが画像がない 90%
                                        } else { if taskCounter2 == 0 && taskCounter3 == 0 { self.stepBar() } }
                                    } // イベント画像なし 90%
                                } else { self.stepBar() }
                                
                                self.uploadLoop1()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Realmから削除
    func deleteRealmDatabase(){
        do{
            try self.realm.write{
                // 存在するデータを消していく
                for i in self.realm.objects(ContentsDB.self).filter("mailAdress == '\(String(self.mailAdress))' AND password == '\(String(self.password))'"){
                    self.realm.delete(i)
                }
                for i in self.realm.objects(EventsDB.self).filter("mailAdress == '\(String(self.mailAdress))' AND password == '\(String(self.password))'"){
                    self.realm.delete(i)
                }
                for i in self.realm.objects(NoticeDB.self).filter("mailAdress == '\(String(self.mailAdress))' AND password == '\(String(self.password))'"){
                    self.realm.delete(i)
                }
                for i in self.realm.objects(MapDB.self).filter("mailAdress == '\(String(self.mailAdress))' AND password == '\(String(self.password))'"){
                    self.realm.delete(i)
                }
            }
        } catch _ as NSError { Analytics.logEvent("error_realm_CreateViewController_deleteContent", parameters: [AnalyticsParameterItemName:"オブジェクトのデータベースからの削除失敗" as String]) }
    }
    
    // 下書き保存
    @IBAction func save(_ sender: Any) {
        let message = "\(self.name.text ?? "＜名前がありません＞")に関係するすべてのデータの保存"
        let alertController: UIAlertController = UIAlertController(title: "下書き保存しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "保存", style: .default){ action in
            // データベースに保存できたらfirebaseにプッシュ
            SVProgressHUD.show()
            if self.savingData(){
                self.successCount = 0.1
                self.pushFirebase()
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // 削除
    @IBAction func deleteContent(_ sender: Any) {
        let message = "\(self.name.text ?? "＜名前がありません＞")に関係するすべてのデータとアカウントの削除"
        let alertController: UIAlertController = UIAlertController(title: "削除しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "削除", style: .destructive){ action in
            SVProgressHUD.show()
            // データベースから削除
            self.deleteRealmDatabase()
            // アカウントを削除する
            if let user = Auth.auth().currentUser{
                user.delete{ error in
                    // エラー判定
                    if let _ = error {
                        Analytics.logEvent("error_account_CreateViewController_deleteContent", parameters: [AnalyticsParameterItemName:"アカウント削除に失敗" as String])
                        SVProgressHUD.showError(withStatus: "削除に失敗")
                        return
                    }
                    SVProgressHUD.showSuccess(withStatus: "削除に成功\nタブ画面に戻ります")
                    // 作成などタブに戻る
                    let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    tabBer.modalPresentationStyle = .fullScreen
                    tabBer.selectedIndex = 3
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        self.present(tabBer, animated: true, completion: nil)
                    }
                }
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // 公開
    @IBAction func releaseContent(_ sender: Any) {
        
        if self.saveData.festivalName.isEmpty {
            SVProgressHUD.showError(withStatus: "公開する前に保存を必ず行って下さい")
            return
        }
        let message = "\(self.saveData.festivalName)をアプリ上で公開"
        let alertController: UIAlertController = UIAlertController(title: "公開しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "公開", style: .default){ action in
            SVProgressHUD.show()
            let firestore = Firestore.firestore()
            let db1 = firestore.collection(Const.FestivalPath).document(self.saveData.uuid)
            let db2 = firestore.collection("catalog").document("nameList")
            let db3 = firestore.collection(Const.DraftPath).document(self.saveData.uuid)
            let batch = firestore.batch()
            let upgradeStatus = UserDefaults.standard.bool(forKey: self.saveData.uuid)
            // 公開データ
            let mainData: [String: Any] = [
                "owner" :  self.accountName.text ?? "NO-NAME",
                "festivalName" : self.saveData.festivalName,
                "date" : self.saveData.date,
                "school" : self.saveData.school,
                "slogan" : self.saveData.slogan,
                "info" : self.saveData.info,
                "latitude" : self.saveData.latitude,
                "longitude" : self.saveData.longitude,
                "link" : [
                    "title1" : self.saveData.title1,
                    "url1" : self.saveData.url1,
                    "title2" : self.saveData.title2,
                    "url2" : self.saveData.url2
                ],
                "upgrade" : upgradeStatus
            ]
            // DRAFTデータ
            let draftData: [String: Any] = [
                "upgrade" : upgradeStatus,
                "database" :  [
                    "published" : true
                ]
            ]
            batch.setData(mainData, forDocument: db1, merge: true)
            batch.setData(draftData, forDocument: db3, merge: true)
            batch.updateData(["list": FieldValue.arrayUnion([self.saveData.festivalName])], forDocument: db2)
            batch.commit() { error in
                if let _ = error {
                    SVProgressHUD.showError(withStatus: "公開に失敗しました")
                    return
                } else {
                    self.finishUpload()
                }
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // アップロードループ１
    func uploadLoop1(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){ self.successCount < 0.9 ? self.uploadloop2() : self.finishUpload() }
    }

    // アップロードループ２
    func uploadloop2(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){ self.successCount < 0.9 ? self.uploadLoop1() : self.finishUpload() }
    }

    // 作成などタブに戻る
    func finishUpload(){
        self.deleteRealmDatabase()
        self.signout(2)
    }

    // プログレスバーを進める
    func stepBar(){
        self.successCount += 0.2
        self.progressView.setProgress(self.successCount, animated: true)
    }
    
    // サインアウトする
    func signout(_ checkout: Int){
        if let _ = Auth.auth().currentUser{
            do {
                try Auth.auth().signOut()
                checkout == 1 ? SVProgressHUD.showSuccess(withStatus: "タブ画面に戻ります") : SVProgressHUD.showSuccess(withStatus: "完了！\nタブ画面に戻ります")
                // 作成などタブに戻る
                let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                tabBer.modalPresentationStyle = .fullScreen
                tabBer.selectedIndex = 3
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.present(tabBer, animated: true, completion: nil)
                }
            } catch _ as NSError {
                checkout == 1 ? SVProgressHUD.showError(withStatus: "ログアウト失敗！\n再度お試しください") : SVProgressHUD.showSuccess(withStatus: "完了！\n右上からログアウトして下さい")
                self.progressView.setProgress(0.0, animated: true)
            }
        }
    }
}
