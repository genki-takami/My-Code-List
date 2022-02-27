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
        
        setupView()
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 注意書きを表示
        popMessage()
    }
    
    // MARK: - ICON IMAGE
    @IBAction private func selectIconImage(_ sender: Any) {
        pickingStart(.photoLibrary, "icon")
    }
    
    // MARK: - BACKGROUND IMAGE
    @IBAction private func selectBackgroundImage(_ sender: Any) {
        pickingStart(.photoLibrary, "background")
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
        deleteCheck()
    }
    
    // MARK: - OPEN TO THE PUBLIC
    @IBAction private func releaseContent(_ sender: Any) {
        releaseCheck()
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
            if let data = (RealmTask.findAll(RealmModel.map) as! Results<Map>)
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
}
