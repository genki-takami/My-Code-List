/*
 作成したプロトコル
 */

import RealmSwift
import FirebaseStorage

protocol DataReturn: AnyObject {
    /// EventImageCreateViewController >>> EventsEditViewController
    func returnData(imageData: UIImage, captionData: String)
}

protocol DataReturn2: AnyObject {
    /// PinEditViewController >>> MapEditViewController
    func returnData2(titleData: String, subtitleData: String, imageData: String)
}

protocol DataReturn3: AnyObject {
    /// URLViewController >>> CreateViewController
    func returnData3(t1: String, u1: String, t2: String, u2: String)
}

protocol UpdateHomeTabData: AnyObject {
    func refreshData()
    func updateStar()
    func onClickStar(_ sender: UIButton, _ indexPath: IndexPath?)
}

protocol FetchHomeTabData: AnyObject {
    func fetchSnapshot()
    func fetchCatalog()
    func fetchHitData()
}

protocol FetchNoticeTabData: AnyObject {
    func receiveNotices(_ favorites: Results<Favorite>)
    func checkTask(_ taskCounter: Int)
    func makeData(_ data: [String:Any], _ festivalName: String) -> Int
}

protocol FetchVoteListData: AnyObject {
    func fetchVoteData()
}

protocol VoteData: AnyObject {
    func vote(for title: String)
}

protocol FetchMainViewData: AnyObject {
    func fetchAllData()
}

protocol MainViewSubMethod: AnyObject {
    func sendComment(_ text: String, _ name: String)
    func backToHomeTab()
    func showBrowser(_ link: String)
}

protocol StartVideo: AnyObject {
    func startVideo()
}

protocol MapViewSubMethod: AnyObject {
    func shiftMapType()
    func browsingMapFile()
}

protocol SignUpAndCreate: AnyObject {
    func signUpOperation(_ address: String, _ password: String, _ displayName: String)
    func createPsyData(_ mail: String, _ pass: String, _ editMainVC: EditMainViewController)
}

protocol SignInAndFetch: AnyObject {
    func makeUpAccountRecord()
    func signInOperation(_ address: String, _ password: String)
}

protocol EditMainViewSubMethod1: AnyObject {
    func popMessage()
    func signOutCheck()
}

protocol EditMainViewSubMethod2: AnyObject {
    func saveCheck()
    func deleteCheck()
    func releaseCheck()
}

protocol EditMainViewSubMethod3: AnyObject {
    func savingData(_ name: String) -> Bool
}

protocol EditMainViewSubMethod4: AnyObject {
    func uploadLoop1()
    func uploadloop2()
    func finishUpload()
    func stepBar()
    func signout(_ checkout: Int)
}

protocol PostFirebase: AnyObject {
    func pushFirebase()
}

protocol BuildData: AnyObject {
    func buildDocumentData(_ contents: Results<ShopDisplay>, _ notices: Results<Notices>, _ events: Results<Event>, _ mapData: Map) -> [Any]
}

protocol UploadImages: AnyObject {
    func uploadOtherImages(_ imgRef: StorageReference, _ neededBox: [Any])
}

protocol DeleteTemporaryData: AnyObject {
    func deleteTemporaryData()
}

protocol SaveContent: AnyObject {
    func saveContent(_ name: String, _ manager: String)
}

protocol SaveNotice: AnyObject {
    func saveNotice(_ title: String, _ content: String)
}

protocol SaveEvent: AnyObject {
    func saveEvent(_ name: String, _ content: String, _ date: String)
}

protocol SetMapsMarker: AnyObject {
    func setPins()
    func setPinsFromCloud()
}

protocol EditMapViewSubMethod: AnyObject {
    func createNewMapData()
    func shiftRegion()
    func shiftMapType()
    func addPin(_ sender: UILongPressGestureRecognizer)
}

protocol SaveMarker: AnyObject {
    func saveMarker()
}
