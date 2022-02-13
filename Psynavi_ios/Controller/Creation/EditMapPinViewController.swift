/*
 編集オブジェクトのマップのピンの編集処理
 */

import UIKit

final class EditMapPinViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var subtitleField: UITextField!
    @IBOutlet private weak var foodIcon: UIImageView!
    @IBOutlet private weak var displayIcon: UIImageView!
    @IBOutlet private weak var attractionIcon: UIImageView!
    @IBOutlet private weak var eventIcon: UIImageView!
    @IBOutlet private weak var benchIcon: UIImageView!
    @IBOutlet private weak var infoIcon: UIImageView!
    @IBOutlet private weak var smokeIcon: UIImageView!
    @IBOutlet private weak var toiletIcon: UIImageView!
    @IBOutlet private weak var trashIcon: UIImageView!
    weak var delegate: DataReturn2?
    var selectedImageIcon = "none"

    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - FOOD
    @IBAction private func didSelectFoodIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            break
        case "display":
            displayIcon.backgroundColor = UIColor.clear
            selectFood()
        case "attraction":
            attractionIcon.backgroundColor = UIColor.clear
            selectFood()
        case "event":
            eventIcon.backgroundColor = UIColor.clear
            selectFood()
        case "bench":
            benchIcon.backgroundColor = UIColor.clear
            selectFood()
        case "info":
            infoIcon.backgroundColor = UIColor.clear
            selectFood()
        case "smoke":
            smokeIcon.backgroundColor = UIColor.clear
            selectFood()
        case "toilet":
            toiletIcon.backgroundColor = UIColor.clear
            selectFood()
        case "trash":
            trashIcon.backgroundColor = UIColor.clear
            selectFood()
        default:
            selectFood()
        }
    }
    
    private func selectFood(){
        foodIcon.backgroundColor = UIColor.lightGray
        selectedImageIcon = "food"
    }
    
    // MARK: - DISPLAY
    @IBAction private func didSelectDisplayIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            foodIcon.backgroundColor = UIColor.clear
            selectDisplay()
        case "display":
            break
        case "attraction":
            attractionIcon.backgroundColor = UIColor.clear
            selectDisplay()
        case "event":
            eventIcon.backgroundColor = UIColor.clear
            selectDisplay()
        case "bench":
            benchIcon.backgroundColor = UIColor.clear
            selectDisplay()
        case "info":
            infoIcon.backgroundColor = UIColor.clear
            selectDisplay()
        case "smoke":
            smokeIcon.backgroundColor = UIColor.clear
            selectDisplay()
        case "toilet":
            toiletIcon.backgroundColor = UIColor.clear
            selectDisplay()
        case "trash":
            trashIcon.backgroundColor = UIColor.clear
            selectDisplay()
        default:
            selectDisplay()
        }
    }
    
    private func selectDisplay(){
        displayIcon.backgroundColor = UIColor.lightGray
        selectedImageIcon = "display"
    }
    
    // MARK: - ATTRACTION
    @IBAction private func didSelectAttractionIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            foodIcon.backgroundColor = UIColor.clear
            selectAttraction()
        case "display":
            displayIcon.backgroundColor = UIColor.clear
            selectAttraction()
        case "attraction":
            break
        case "event":
            eventIcon.backgroundColor = UIColor.clear
            selectAttraction()
        case "bench":
            benchIcon.backgroundColor = UIColor.clear
            selectAttraction()
        case "info":
            infoIcon.backgroundColor = UIColor.clear
            selectAttraction()
        case "smoke":
            smokeIcon.backgroundColor = UIColor.clear
            selectAttraction()
        case "toilet":
            toiletIcon.backgroundColor = UIColor.clear
            selectAttraction()
        case "trash":
            trashIcon.backgroundColor = UIColor.clear
            selectAttraction()
        default:
            selectAttraction()
        }
    }
    
    private func selectAttraction(){
        attractionIcon.backgroundColor = UIColor.lightGray
        selectedImageIcon = "attraction"
    }
    
    // MARK: - EVENT
    @IBAction private func didSelectEventIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            foodIcon.backgroundColor = UIColor.clear
            selectEvent()
        case "display":
            displayIcon.backgroundColor = UIColor.clear
            selectEvent()
        case "attraction":
            attractionIcon.backgroundColor = UIColor.clear
            selectEvent()
        case "event":
            break
        case "bench":
            benchIcon.backgroundColor = UIColor.clear
            selectEvent()
        case "info":
            infoIcon.backgroundColor = UIColor.clear
            selectEvent()
        case "smoke":
            smokeIcon.backgroundColor = UIColor.clear
            selectEvent()
        case "toilet":
            toiletIcon.backgroundColor = UIColor.clear
            selectEvent()
        case "trash":
            trashIcon.backgroundColor = UIColor.clear
            selectEvent()
        default:
            selectEvent()
        }
    }
    
    private func selectEvent(){
        eventIcon.backgroundColor = UIColor.lightGray
        selectedImageIcon = "event"
    }
    
    // MARK: - BENCH
    @IBAction private func didSelectBenchIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            foodIcon.backgroundColor = UIColor.clear
            selectBench()
        case "display":
            displayIcon.backgroundColor = UIColor.clear
            selectBench()
        case "attraction":
            attractionIcon.backgroundColor = UIColor.clear
            selectBench()
        case "event":
            eventIcon.backgroundColor = UIColor.clear
            selectBench()
        case "bench":
            break
        case "info":
            infoIcon.backgroundColor = UIColor.clear
            selectBench()
        case "smoke":
            smokeIcon.backgroundColor = UIColor.clear
            selectBench()
        case "toilet":
            toiletIcon.backgroundColor = UIColor.clear
            selectBench()
        case "trash":
            trashIcon.backgroundColor = UIColor.clear
            selectBench()
        default:
            selectBench()
        }
    }
    
    private func selectBench(){
        benchIcon.backgroundColor = UIColor.lightGray
        selectedImageIcon = "bench"
    }
    
    // MARK: - INFO
    @IBAction private func didSelectInfoIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            foodIcon.backgroundColor = UIColor.clear
            selectInfo()
        case "display":
            displayIcon.backgroundColor = UIColor.clear
            selectInfo()
        case "attraction":
            attractionIcon.backgroundColor = UIColor.clear
            selectInfo()
        case "event":
            eventIcon.backgroundColor = UIColor.clear
            selectInfo()
        case "bench":
            benchIcon.backgroundColor = UIColor.clear
            selectInfo()
        case "info":
            break
        case "smoke":
            smokeIcon.backgroundColor = UIColor.clear
            selectInfo()
        case "toilet":
            toiletIcon.backgroundColor = UIColor.clear
            selectInfo()
        case "trash":
            trashIcon.backgroundColor = UIColor.clear
            selectInfo()
        default:
            selectInfo()
        }
    }
    
    private func selectInfo(){
        infoIcon.backgroundColor = UIColor.lightGray
        selectedImageIcon = "info"
    }
    
    // MARK: - SMOKE
    @IBAction private func didSelectSmokeIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            foodIcon.backgroundColor = UIColor.clear
            selectSmoke()
        case "display":
            displayIcon.backgroundColor = UIColor.clear
            selectSmoke()
        case "attraction":
            attractionIcon.backgroundColor = UIColor.clear
            selectSmoke()
        case "event":
            eventIcon.backgroundColor = UIColor.clear
            selectSmoke()
        case "bench":
            benchIcon.backgroundColor = UIColor.clear
            selectSmoke()
        case "info":
            infoIcon.backgroundColor = UIColor.clear
            selectSmoke()
        case "smoke":
            break
        case "toilet":
            toiletIcon.backgroundColor = UIColor.clear
            selectSmoke()
        case "trash":
            trashIcon.backgroundColor = UIColor.clear
            selectSmoke()
        default:
            selectSmoke()
        }
    }
    
    private func selectSmoke(){
        smokeIcon.backgroundColor = UIColor.lightGray
        selectedImageIcon = "smoke"
    }
    
    // MARK: - TOILET
    @IBAction private func didSelectToiletIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
            foodIcon.backgroundColor = UIColor.clear
            selectToilet()
        case "display":
            displayIcon.backgroundColor = UIColor.clear
            selectToilet()
        case "attraction":
            attractionIcon.backgroundColor = UIColor.clear
            selectToilet()
        case "event":
            eventIcon.backgroundColor = UIColor.clear
            selectToilet()
        case "bench":
            benchIcon.backgroundColor = UIColor.clear
            selectToilet()
        case "info":
            infoIcon.backgroundColor = UIColor.clear
            selectToilet()
        case "smoke":
            smokeIcon.backgroundColor = UIColor.clear
            selectToilet()
        case "toilet":
            break
        case "trash":
            trashIcon.backgroundColor = UIColor.clear
            selectToilet()
        default:
            selectToilet()
        }
    }
    
    private func selectToilet(){
        toiletIcon.backgroundColor = UIColor.lightGray
        selectedImageIcon = "toilet"
    }
    
    // MARK: - TRASH
    @IBAction private func didSelectTrashIcon(_ sender: Any) {
        switch selectedImageIcon{
        case "food":
        foodIcon.backgroundColor = UIColor.clear
        selectTrash()
        case "display":
        displayIcon.backgroundColor = UIColor.clear
        selectTrash()
        case "attraction":
        attractionIcon.backgroundColor = UIColor.clear
        selectTrash()
        case "event":
        eventIcon.backgroundColor = UIColor.clear
        selectTrash()
        case "bench":
        benchIcon.backgroundColor = UIColor.clear
        selectTrash()
        case "info":
        infoIcon.backgroundColor = UIColor.clear
        selectTrash()
        case "smoke":
        smokeIcon.backgroundColor = UIColor.clear
        selectTrash()
        case "toilet":
        toiletIcon.backgroundColor = UIColor.clear
        selectTrash()
        case "trash":
            break
        default:
        selectTrash()
        }
    }
    
    private func selectTrash(){
        trashIcon.backgroundColor = UIColor.lightGray
        selectedImageIcon = "trash"
    }
    
    // MARK: - SHUTDOWN
    @IBAction private func showDown(_ sender: Any) {
        
        if let mainTitle = titleField.text, let subtitle = subtitleField.text {
            
            if mainTitle.isEmpty || subtitle.isEmpty || selectedImageIcon == "none" {
                DisplayPop.error("タイトルとサブタイトルを記入し、アイコンを選択してください")
            } else {
                // 遷移元にデータを渡す
                delegate?.returnData2(titleData: mainTitle, subtitleData: subtitle, imageData: selectedImageIcon)
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
