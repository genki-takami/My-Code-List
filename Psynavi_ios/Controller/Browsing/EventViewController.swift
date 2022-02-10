/*
 公開オブジェクトのイベント詳細表示の処理
 */

import UIKit
import FirebaseStorage

final class EventViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var eventCollection: UICollectionView!
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventDateLabel: UILabel!
    @IBOutlet private weak var eventCaptionTextView: UITextView!
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
        
        setUpEventData()
    }
    
    // MARK: - SET-UP
    private func setUpEventData() {
        // テキストデータ
        eventTitleLabel.text = eventTitle
        eventDateLabel.text = eventDate
        eventCaptionTextView.text = caption
        // Storageにある画像データのパスをrefArrayに加える
        if imageCaptions.count > 0 {
            for cap in imageCaptions {
                let ref = FetchData.getPath4StorageReference(uuid, PathName.EventImagePath, eventTitle, cap.prefix(10) + ".jpg")
                refArray.append(ref)
            }
        }
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toReadingImageShowSegue" {
            let eventImageVC = segue.destination as! EventImageViewController
            eventImageVC.selectedImage = selectedImage
            eventImageVC.selectedCaption = selectedCaption
        }
    }
    
    // MARK: - PLAY VIDEO
    @IBAction private func playVideo(_ sender: Any) {
        
        if video {
            // 動画は投稿済み
            let fileName = self.eventTitle + ".mp4"
            let videoRef = FetchData.getPath3StorageReference(uuid, PathName.EventVideoPath, fileName)

            FetchData.downloadVideo(videoRef) { result in
                switch result {
                case .success(let url):
                    self.playing(url!)
                    self.popAlert()
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        } else {
            DisplayPop.error("動画は投稿されていません")
        }
    }
    
    // ストリーミング中であることを知らせる
    private func popAlert() {
        DisplayPop.showMessage("ストリーミング中")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            DisplayPop.dismiss()
        }
    }
}
