/*
 編集オブジェクトのマップのピンの編集処理
 */

import UIKit
import SVProgressHUD

final class EditMapPinViewController: UIViewController {
    
    // 変数
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var subtitleField: UITextField!
    @IBOutlet weak var foodIcon: UIImageView!
    @IBOutlet weak var displayIcon: UIImageView!
    @IBOutlet weak var attractionIcon: UIImageView!
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var benchIcon: UIImageView!
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var smokeIcon: UIImageView!
    @IBOutlet weak var toiletIcon: UIImageView!
    @IBOutlet weak var trashIcon: UIImageView!
    var delegate: DataReturn2?
    var selectedImageIcon = "none"

    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // アイコン画像をタップして選択
    @IBAction func didSelectFoodIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            break
        case "display":
            self.displayIcon.backgroundColor = UIColor.clear
            self.selectFood()
        case "attraction":
            self.attractionIcon.backgroundColor = UIColor.clear
            self.selectFood()
        case "event":
            self.eventIcon.backgroundColor = UIColor.clear
            self.selectFood()
        case "bench":
            self.benchIcon.backgroundColor = UIColor.clear
            self.selectFood()
        case "info":
            self.infoIcon.backgroundColor = UIColor.clear
            self.selectFood()
        case "smoke":
            self.smokeIcon.backgroundColor = UIColor.clear
            self.selectFood()
        case "toilet":
            self.toiletIcon.backgroundColor = UIColor.clear
            self.selectFood()
        case "trash":
            self.trashIcon.backgroundColor = UIColor.clear
            self.selectFood()
        default:
            self.selectFood()
        }
    }
    
    func selectFood(){
        self.foodIcon.backgroundColor = UIColor.lightGray
        self.selectedImageIcon = "food"
    }
    
    // アイコン画像をタップして選択
    @IBAction func didSelectDisplayIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            self.foodIcon.backgroundColor = UIColor.clear
            self.selectDisplay()
        case "display":
            break
        case "attraction":
            self.attractionIcon.backgroundColor = UIColor.clear
            self.selectDisplay()
        case "event":
            self.eventIcon.backgroundColor = UIColor.clear
            self.selectDisplay()
        case "bench":
            self.benchIcon.backgroundColor = UIColor.clear
            self.selectDisplay()
        case "info":
            self.infoIcon.backgroundColor = UIColor.clear
            self.selectDisplay()
        case "smoke":
            self.smokeIcon.backgroundColor = UIColor.clear
            self.selectDisplay()
        case "toilet":
            self.toiletIcon.backgroundColor = UIColor.clear
            self.selectDisplay()
        case "trash":
            self.trashIcon.backgroundColor = UIColor.clear
            self.selectDisplay()
        default:
            self.selectDisplay()
        }
    }
    
    func selectDisplay(){
        self.displayIcon.backgroundColor = UIColor.lightGray
        self.selectedImageIcon = "display"
    }
    
    // アイコン画像をタップして選択
    @IBAction func didSelectAttractionIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            self.foodIcon.backgroundColor = UIColor.clear
            self.selectAttraction()
        case "display":
            self.displayIcon.backgroundColor = UIColor.clear
            self.selectAttraction()
        case "attraction":
            break
        case "event":
            self.eventIcon.backgroundColor = UIColor.clear
            self.selectAttraction()
        case "bench":
            self.benchIcon.backgroundColor = UIColor.clear
            self.selectAttraction()
        case "info":
            self.infoIcon.backgroundColor = UIColor.clear
            self.selectAttraction()
        case "smoke":
            self.smokeIcon.backgroundColor = UIColor.clear
            self.selectAttraction()
        case "toilet":
            self.toiletIcon.backgroundColor = UIColor.clear
            self.selectAttraction()
        case "trash":
            self.trashIcon.backgroundColor = UIColor.clear
            self.selectAttraction()
        default:
            self.selectAttraction()
        }
    }
    
    func selectAttraction(){
        self.attractionIcon.backgroundColor = UIColor.lightGray
        self.selectedImageIcon = "attraction"
    }
    
    // アイコン画像をタップして選択
    @IBAction func didSelectEventIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            self.foodIcon.backgroundColor = UIColor.clear
            self.selectEvent()
        case "display":
            self.displayIcon.backgroundColor = UIColor.clear
            self.selectEvent()
        case "attraction":
            self.attractionIcon.backgroundColor = UIColor.clear
            self.selectEvent()
        case "event":
            break
        case "bench":
            self.benchIcon.backgroundColor = UIColor.clear
            self.selectEvent()
        case "info":
            self.infoIcon.backgroundColor = UIColor.clear
            self.selectEvent()
        case "smoke":
            self.smokeIcon.backgroundColor = UIColor.clear
            self.selectEvent()
        case "toilet":
            self.toiletIcon.backgroundColor = UIColor.clear
            self.selectEvent()
        case "trash":
            self.trashIcon.backgroundColor = UIColor.clear
            self.selectEvent()
        default:
            self.selectEvent()
        }
    }
    
    func selectEvent(){
        self.eventIcon.backgroundColor = UIColor.lightGray
        self.selectedImageIcon = "event"
    }
    
    // アイコン画像をタップして選択
    @IBAction func didSelectBenchIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            self.foodIcon.backgroundColor = UIColor.clear
            self.selectBench()
        case "display":
            self.displayIcon.backgroundColor = UIColor.clear
            self.selectBench()
        case "attraction":
            self.attractionIcon.backgroundColor = UIColor.clear
            self.selectBench()
        case "event":
            self.eventIcon.backgroundColor = UIColor.clear
            self.selectBench()
        case "bench":
            break
        case "info":
            self.infoIcon.backgroundColor = UIColor.clear
            self.selectBench()
        case "smoke":
            self.smokeIcon.backgroundColor = UIColor.clear
            self.selectBench()
        case "toilet":
            self.toiletIcon.backgroundColor = UIColor.clear
            self.selectBench()
        case "trash":
            self.trashIcon.backgroundColor = UIColor.clear
            self.selectBench()
        default:
            self.selectBench()
        }
    }
    
    func selectBench(){
        self.benchIcon.backgroundColor = UIColor.lightGray
        self.selectedImageIcon = "bench"
    }
    
    // アイコン画像をタップして選択
    @IBAction func didSelectInfoIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            self.foodIcon.backgroundColor = UIColor.clear
            self.selectInfo()
        case "display":
            self.displayIcon.backgroundColor = UIColor.clear
            self.selectInfo()
        case "attraction":
            self.attractionIcon.backgroundColor = UIColor.clear
            self.selectInfo()
        case "event":
            self.eventIcon.backgroundColor = UIColor.clear
            self.selectInfo()
        case "bench":
            self.benchIcon.backgroundColor = UIColor.clear
            self.selectInfo()
        case "info":
            break
        case "smoke":
            self.smokeIcon.backgroundColor = UIColor.clear
            self.selectInfo()
        case "toilet":
            self.toiletIcon.backgroundColor = UIColor.clear
            self.selectInfo()
        case "trash":
            self.trashIcon.backgroundColor = UIColor.clear
            self.selectInfo()
        default:
            self.selectInfo()
        }
    }
    
    func selectInfo(){
        self.infoIcon.backgroundColor = UIColor.lightGray
        self.selectedImageIcon = "info"
    }
    
    // アイコン画像をタップして選択
    @IBAction func didSelectSmokeIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            self.foodIcon.backgroundColor = UIColor.clear
            self.selectSmoke()
        case "display":
            self.displayIcon.backgroundColor = UIColor.clear
            self.selectSmoke()
        case "attraction":
            self.attractionIcon.backgroundColor = UIColor.clear
            self.selectSmoke()
        case "event":
            self.eventIcon.backgroundColor = UIColor.clear
            self.selectSmoke()
        case "bench":
            self.benchIcon.backgroundColor = UIColor.clear
            self.selectSmoke()
        case "info":
            self.infoIcon.backgroundColor = UIColor.clear
            self.selectSmoke()
        case "smoke":
            break
        case "toilet":
            self.toiletIcon.backgroundColor = UIColor.clear
            self.selectSmoke()
        case "trash":
            self.trashIcon.backgroundColor = UIColor.clear
            self.selectSmoke()
        default:
            self.selectSmoke()
        }
    }
    
    func selectSmoke(){
        self.smokeIcon.backgroundColor = UIColor.lightGray
        self.selectedImageIcon = "smoke"
    }
    
    // アイコン画像をタップして選択
    @IBAction func didSelectToiletIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            self.foodIcon.backgroundColor = UIColor.clear
            self.selectToilet()
        case "display":
            self.displayIcon.backgroundColor = UIColor.clear
            self.selectToilet()
        case "attraction":
            self.attractionIcon.backgroundColor = UIColor.clear
            self.selectToilet()
        case "event":
            self.eventIcon.backgroundColor = UIColor.clear
            self.selectToilet()
        case "bench":
            self.benchIcon.backgroundColor = UIColor.clear
            self.selectToilet()
        case "info":
            self.infoIcon.backgroundColor = UIColor.clear
            self.selectToilet()
        case "smoke":
            self.smokeIcon.backgroundColor = UIColor.clear
            self.selectToilet()
        case "toilet":
            break
        case "trash":
            self.trashIcon.backgroundColor = UIColor.clear
            self.selectToilet()
        default:
            self.selectToilet()
        }
    }
    
    func selectToilet(){
        self.toiletIcon.backgroundColor = UIColor.lightGray
        self.selectedImageIcon = "toilet"
    }
    
    // アイコン画像をタップして選択
    @IBAction func didSelectTrashIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            self.foodIcon.backgroundColor = UIColor.clear
            self.selectTrash()
        case "display":
            self.displayIcon.backgroundColor = UIColor.clear
            self.selectTrash()
        case "attraction":
            self.attractionIcon.backgroundColor = UIColor.clear
            self.selectTrash()
        case "event":
            self.eventIcon.backgroundColor = UIColor.clear
            self.selectTrash()
        case "bench":
            self.benchIcon.backgroundColor = UIColor.clear
            self.selectTrash()
        case "info":
            self.infoIcon.backgroundColor = UIColor.clear
            self.selectTrash()
        case "smoke":
            self.smokeIcon.backgroundColor = UIColor.clear
            self.selectTrash()
        case "toilet":
            self.toiletIcon.backgroundColor = UIColor.clear
            self.selectTrash()
        case "trash":
            break
        default:
            self.selectTrash()
        }
    }
    
    func selectTrash(){
        self.trashIcon.backgroundColor = UIColor.lightGray
        self.selectedImageIcon = "trash"
    }
    
    // 閉じる
    @IBAction func showDown(_ sender: Any) {
        if let t1 = titleField.text, let t2 = subtitleField.text{
            
            if t1.isEmpty || t2.isEmpty || selectedImageIcon == "none"{
                SVProgressHUD.showError(withStatus: "タイトルとサブタイトルを記入し、アイコンを選択してください")
            } else {
                // 遷移元にデータを渡す
                delegate?.returnData2(titleData: t1, subtitleData: t2, imageData: selectedImageIcon)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
