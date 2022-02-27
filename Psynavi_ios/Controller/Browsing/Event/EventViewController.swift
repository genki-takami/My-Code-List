/*
 公開オブジェクトのイベント詳細表示の処理
 */

import UIKit
import FirebaseStorage

final class EventViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var eventCollection: UICollectionView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventCaptionTextView: UITextView!
    var uuid, eventTitle, eventDate: String!
    var caption: String!
    var imageCaptions: [String]!
    var video: Bool!
    var refArray = [StorageReference]()
    var selectedCaption: String!
    var selectedImage: UIImage!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventCollection.delegate = self
        eventCollection.dataSource = self
        
        setupView()
    }
    
    // MARK: - PLAY VIDEO
    @IBAction private func playVideo(_ sender: Any) {
        
        startVideo()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toReadingImageShowSegue" {
            let eventImageVC = segue.destination as! EventImageViewController
            eventImageVC.selectedImage = selectedImage
            eventImageVC.selectedCaption = selectedCaption
        }
    }
}
