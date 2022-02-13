/*
 作成・更新・公開・アカウント削除の処理
 */

import UIKit
import RealmSwift

final class EditMainViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Property
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var slogan: UITextField!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var accountName: UILabel!
    var successCount: Float = 0.1
    var isNewObject, upgrade: Bool!
    var mailAdress, password: String!
    var title1 = "", url1 = "", title2 = "", url2 = ""
    var saveData: PsyData!
    var contentImage = [String]()
    var eventImage = [String]()
    var alertFinish = false
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIをセットアップ
        setUpUIData()
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 注意書きを表示
        popMessage()
    }
    
    // アイコンのライブラリピッカー
    @IBAction private func selectIconImage(_ sender: Any) {
        pickingStart(.photoLibrary, "icon")
    }
    
    // ワイド(背景)画像のライブラリピッカー
    @IBAction private func selectBackgroundImage(_ sender: Any) {
        pickingStart(.photoLibrary, "background")
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "settingLinkSegue":
            let editLinkVC = segue.destination as! EditLinkViewController
            editLinkVC.receiveT1 = title1
            editLinkVC.receiveU1 = url1
            editLinkVC.receiveT2 = title2
            editLinkVC.receiveU2 = url2
            editLinkVC.delegate = self
        case "listSegue":
            let editContentListVC = segue.destination as! EditContentListViewController
            editContentListVC.mailAdress = mailAdress
            editContentListVC.password = password
        case "createNoticeSegue":
            let editNoticeListVC = segue.destination as! EditNoticeListViewController
            editNoticeListVC.mailAdress = mailAdress
            editNoticeListVC.password = password
        case "createEventSegue":
            let editEventListVC = segue.destination as! EditEventListViewController
            editEventListVC.mailAdress = mailAdress
            editEventListVC.password = password
        case "createMapSegue":
            let editMapVC = segue.destination as! EditMapViewController
            editMapVC.mailAdress = mailAdress
            editMapVC.password = password
            if let data = (DataProcessing.findAll(RealmModel.map) as! Results<Map>)
                                            .first(where: { $0.mailAdress == mailAdress && $0.password == password }) {
                editMapVC.festivalData = data
            } else {
                editMapVC.downloadLat = saveData.latitude
                editMapVC.downloadLon = saveData.longitude
                editMapVC.downloadableMarkers = saveData.marker
                editMapVC.uuid = saveData.uuid
            }
        case "voteOptionSegue":
            let voteOptionPurchaseVC = segue.destination as! VoteOptionPurchaseViewController
            voteOptionPurchaseVC.upgrade = upgrade
            voteOptionPurchaseVC.uuid = saveData.uuid
        default:
            break
        }
    }
    
    // MARK: - SIGN OUT
    @IBAction private func logout(_ sender: Any) {
        signOutCheck()
    }
    
    // MARK: - SAVE DRAFT DATA
    @IBAction private func save(_ sender: Any) {
        saveCheck()
    }
    
    // MARK: - DELETE CONTENT AND ACCOUNT
    @IBAction private func deleteContent(_ sender: Any) {
        let message = "\(self.name.text ?? "＜名前がありません＞")に関係するすべてのデータとアカウントの削除"
        let alertController = UIAlertController(title: "削除しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "削除", style: .destructive){ action in
            DisplayPop.show()
            // データベースから削除
            self.deleteRealmDatabase()
            // アカウントを削除する
            if let user = AuthModule.currentUser() {
                user.delete{ error in
                    // エラー判定
                    if let _ = error {
                        //SVProgressHUD.showError(withStatus: "削除に失敗")
                        return
                    }
                    //SVProgressHUD.showSuccess(withStatus: "削除に成功\nタブ画面に戻ります")
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
    
    // MARK: - OPEN TO THE PUBLIC
    @IBAction private func releaseContent(_ sender: Any) {
        
        if self.saveData.festivalName.isEmpty {
            //SVProgressHUD.showError(withStatus: "公開する前に保存を必ず行って下さい")
            return
        }
        let message = "\(self.saveData.festivalName)をアプリ上で公開"
        let alertController = UIAlertController(title: "公開しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "公開", style: .default){ action in
            DisplayPop.show()
            let firestore = Firestore.firestore()
            let db1 = firestore.collection(PathName.FestivalPath).document(self.saveData.uuid)
            let db2 = firestore.collection("catalog").document("nameList")
            let db3 = firestore.collection(PathName.DraftPath).document(self.saveData.uuid)
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
}
