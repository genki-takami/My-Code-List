/*
 公開オブジェクトの表示処理
 */

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
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
    private var url1, url2, mapFileUrl: String!
    private var latitude, longitude: Double!
    var uuid: String!
    var shops = [[String : Any]](), displays = [[String : Any]]()
    var events = [[String : Any]](), comments = [[String:Any]]()
    var maps, databaseProperty: [String : Any]!
    var notices = [NoticeParam]()
    var isFirstFetch = true
    private var upgrade = false
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - JUMP TO WEBSITE 1
    @IBAction private func goToWebsite1(_ sender: Any) {
        
        guard let jumpLink1 = url1 else { return }
        showBrowser(jumpLink1)
    }
    
    // MARK: - JUMP TO WEBSITE 2
    @IBAction private func goToWebsite2(_ sender: Any) {
        
        guard let jumpLink2 = self.url2 else { return }
        showBrowser(jumpLink2)
    }
    
    /// コメントを送る
    @IBAction private func sendComment(_ sender: Any) {
        
        guard let cmt = commentText.text, let cmn = commentName.text else { return }
        
        if cmt.isEmpty {
            Modal.showError("コメントがありません！")
        } else {
            sendComment(cmt, cmn)
        }
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        
        if isFirstFetch {
            
            Modal.show()
            
            FetchData.fetchDocument(PathName.FestivalPath, uuid) { result in
                switch result {
                case .success(let data):
                    // メインデータ
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
                    // databasePropertyを参照して他のデータも持ってくる
                    self.fetchAllData()
                    
                case .failure(let error):
                    self.backToHomeTab()
                    Modal.showError(String(describing: error))
                }
            }
        }
        
        super.viewDidAppear(animated)
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "lookShopSegue":
            let shopListVC = segue.destination as! ShopListViewController
            shopListVC.shops = shops
        case "lookDisplaySegue":
            let displayListVC = segue.destination as! DisplayListViewController
            displayListVC.displays = displays
        case "lookEventSegue":
            let eventListVC = segue.destination as! EventListViewController
            eventListVC.events = events
        case "lookMapSegue":
            let mapVC = segue.destination as! MapViewController
            mapVC.latitude = latitude
            mapVC.longitude = longitude
            mapVC.data = maps
            mapVC.mapFileUrl = mapFileUrl
        case "lookNoticeSegue":
            let noticeListVC = segue.destination as! NoticeListViewController
            noticeListVC.notices = notices
        case "toCommentListView":
            let commentListVC = segue.destination as! CommentListViewController
            commentListVC.comments = comments
        case "voteListSegue":
            let voteListVC = segue.destination as! VoteListViewController
            voteListVC.uid = uuid
            voteListVC.upgrade = upgrade
        default:
            break
        }
    }
}
