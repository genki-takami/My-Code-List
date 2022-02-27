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

        setDismissKeyboard()
    }
    
    private func clearBackgroundColor() {
        foodIcon.backgroundColor = .clear
        displayIcon.backgroundColor = .clear
        attractionIcon.backgroundColor = .clear
        eventIcon.backgroundColor = .clear
        benchIcon.backgroundColor = .clear
        infoIcon.backgroundColor = .clear
        smokeIcon.backgroundColor = .clear
        toiletIcon.backgroundColor = .clear
        trashIcon.backgroundColor = .clear
    }
    
    // MARK: - FOOD
    @IBAction private func didSelectFoodIcon(_ sender: Any) {
        
        switch selectedImageIcon {
        case "food":
            break
        default:
            clearBackgroundColor()
            foodIcon.backgroundColor = .lightGray
            selectedImageIcon = "food"
        }
    }
    
    // MARK: - DISPLAY
    @IBAction private func didSelectDisplayIcon(_ sender: Any) {
        
        switch selectedImageIcon {
        case "display":
            break
         default:
            clearBackgroundColor()
            displayIcon.backgroundColor = .lightGray
            selectedImageIcon = "display"
        }
    }
    
    // MARK: - ATTRACTION
    @IBAction private func didSelectAttractionIcon(_ sender: Any) {
        
        switch selectedImageIcon {
        case "attraction":
            break
        default:
            clearBackgroundColor()
            attractionIcon.backgroundColor = .lightGray
            selectedImageIcon = "attraction"
        }
    }
    
    // MARK: - EVENT
    @IBAction private func didSelectEventIcon(_ sender: Any) {
        
        switch selectedImageIcon {
        case "event":
            break
        default:
            clearBackgroundColor()
            eventIcon.backgroundColor = .lightGray
            selectedImageIcon = "event"
        }
    }
    
    // MARK: - BENCH
    @IBAction private func didSelectBenchIcon(_ sender: Any) {
        
        switch selectedImageIcon {
        case "bench":
            break
        default:
            clearBackgroundColor()
            benchIcon.backgroundColor = .lightGray
            selectedImageIcon = "bench"
        }
    }
    
    // MARK: - INFO
    @IBAction private func didSelectInfoIcon(_ sender: Any) {
        
        switch selectedImageIcon {
        case "info":
            break
        default:
            clearBackgroundColor()
            infoIcon.backgroundColor = .lightGray
            selectedImageIcon = "info"
        }
    }
    
    // MARK: - SMOKE
    @IBAction private func didSelectSmokeIcon(_ sender: Any) {
        
        switch selectedImageIcon {
        case "smoke":
            break
        default:
            clearBackgroundColor()
            smokeIcon.backgroundColor = .lightGray
            selectedImageIcon = "smoke"
        }
    }
    
    // MARK: - TOILET
    @IBAction private func didSelectToiletIcon(_ sender: Any) {
        
        switch selectedImageIcon {
        case "toilet":
            break
        default:
            clearBackgroundColor()
            toiletIcon.backgroundColor = .lightGray
            selectedImageIcon = "toilet"
        }
    }
    
    // MARK: - TRASH
    @IBAction private func didSelectTrashIcon(_ sender: Any) {
        
        switch selectedImageIcon {
        case "trash":
            break
        default:
            clearBackgroundColor()
            trashIcon.backgroundColor = .lightGray
            selectedImageIcon = "trash"
        }
    }
    
    // MARK: - SHUTDOWN
    @IBAction private func showDown(_ sender: Any) {
        
        guard let mainTitle = titleField.text, let subtitle = subtitleField.text else { return }
        
        if mainTitle.isEmpty || subtitle.isEmpty || selectedImageIcon == "none" {
            Modal.showError("タイトルとサブタイトルを記入し、アイコンを選択してください")
        } else {
            /// 遷移元にデータを渡す
            delegate?.returnData2(titleData: mainTitle, subtitleData: subtitle, imageData: selectedImageIcon)
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
