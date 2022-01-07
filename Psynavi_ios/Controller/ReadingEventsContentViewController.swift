/*
 公開オブジェクトのイベント詳細表示の処理
 */

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD
import AVKit

class ReadingEventsContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 変数
    @IBOutlet weak var eventCollection: UICollectionView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventCaptionTextView: UITextView!
    var uuid, eventTitle, eventDate, caption, selectedCaption: String!
    var imageCaptions: [String]!
    var refArray: [StorageReference] = []
    var selectedImage: UIImage!
    var video: Bool!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート・データソース
        eventCollection.delegate = self
        eventCollection.dataSource = self
        // テキストデータ
        eventTitleLabel.text = eventTitle
        eventDateLabel.text = eventDate
        eventCaptionTextView.text = caption
        // Storageにある画像データのパスをrefArrayに加える
        if !imageCaptions.isEmpty{
            for i in imageCaptions{
                self.refArray.append(Storage.storage().reference().child(self.uuid).child(Const.EventImagePath).child(self.eventTitle).child(i.prefix(10) + ".jpg"))
            }
        }
    }
    
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return refArray.count
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "readingCollectionCell", for: indexPath)
        
        let imageView = imageCell.contentView.viewWithTag(1) as! UIImageView
        // 画像データ
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: refArray[indexPath.row])
        
        // セルのタップ検知
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        imageCell.addGestureRecognizer(tapGesture)
        
        return imageCell
    }
    
    // セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer){
        collectionView(self.eventCollection, didSelectItemAt: sender.indexValue!)
    }
    
    // セルが選択された時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // セル画像とキャプションを持って画面遷移
        let cell = collectionView.cellForItem(at: indexPath)
        let cellImageView = cell?.contentView.viewWithTag(1) as! UIImageView
        selectedImage = cellImageView.image
        selectedCaption = self.imageCaptions[indexPath.row]
        if selectedImage != nil || selectedCaption != nil{
            performSegue(withIdentifier: "toReadingImageShowSegue",sender: nil)
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toReadingImageShowSegue" {
            let readingEventImageShowViewController:ReadingEventImageShowViewController = segue.destination as! ReadingEventImageShowViewController
            readingEventImageShowViewController.selectedImage = selectedImage
            readingEventImageShowViewController.selectedCaption = selectedCaption
        }
    }
    
    // セルのサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // １行３セル
        let cellSize:CGFloat = self.view.frame.width / 3
        // 正方形で返す
        return CGSize(width: cellSize, height: cellSize)
    }
    
    // 再生準備
    @IBAction func playVideo(_ sender: Any) {
        // クラウドストレージから参照
        if self.video{
            // アップロード済み
            let fileName = self.eventTitle + ".mp4"
            let videoRef = Storage.storage().reference().child(self.uuid).child("event-video").child(fileName)
            videoRef.downloadURL { u, err in
                if let _ = err{
                    SVProgressHUD.showError(withStatus: "エラーが発生しました")
                } else {
                    self.playing(u! as NSURL)
                    SVProgressHUD.show(withStatus: "ストリーミング中")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        SVProgressHUD.dismiss()
                    }
                }
            }
        } else {
            SVProgressHUD.showInfo(withStatus: "動画は投稿されていません")
        }
    }
    
    // 動画を再生
    func playing(_ url: NSURL){
        let player = AVPlayer(url: url as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
