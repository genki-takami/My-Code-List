/*
 編集オブジェクトのイベントの編集処理
 */

import UIKit

final class EditEventViewController: CreationUIViewController {
    
    // MARK: - Property
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventContent: UITextView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var eventDate: UITextField!
    var selectedImage: UIImage!
    var selectedCaption: String!
    var event: Event!

    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollection.delegate = self
        imageCollection.dataSource = self
        
        setupView()
    }
    
    // MARK: - SELECT IMAGE
    @IBAction private func selectImages(_ sender: Any) {
        pickingStart(.photoLibrary)
    }
    
    // MARK: - SAVE
    @IBAction private func save(_ sender: Any) {
        
        guard let name = eventName.text, let content = eventContent.text, let date = eventDate.text else { return }
        saveEvent(name, content, date)
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toImageShowCell" {
            let editEventImagePC = segue.destination as! EditEventImagePreviewController
            editEventImagePC.selectedImage = selectedImage
            editEventImagePC.selectedCaption = selectedCaption
        }
    }
}
