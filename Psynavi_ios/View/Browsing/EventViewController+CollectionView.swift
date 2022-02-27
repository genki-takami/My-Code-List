/*
 EventViewControllerの拡張
 */

import UIKit
import FirebaseStorageUI

extension EventViewController: UICollectionViewDelegate {
    
    /// セルをタップ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        let cellImageView = cell?.contentView.viewWithTag(1) as! UIImageView
        /// セル画像とキャプションを持って画面遷移
        selectedImage = cellImageView.image
        selectedCaption = imageCaptions[indexPath.row]
        
        if selectedImage != nil || selectedCaption != nil {
            performSegue(withIdentifier: "toReadingImageShowSegue",sender: nil)
        }
    }
}

extension EventViewController: UICollectionViewDataSource {
    
    /// セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return refArray.count
    }
    
    /// セルの内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageCell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "readingCollectionCell", for: indexPath)
        let imageView = imageCell.contentView.viewWithTag(1) as! UIImageView
        
        /// 画像データ
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: refArray[indexPath.row])
        
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        imageCell.addGestureRecognizer(tapGesture)
        
        return imageCell
    }
    
    @objc func goToDetail(sender: MyTapGestureRecognizer){
        collectionView(eventCollection, didSelectItemAt: sender.indexValue!)
    }
}

extension EventViewController: UICollectionViewDelegateFlowLayout {
    
    /// セルのレイアウト
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// １行３セル
        let cellSize: CGFloat = self.view.frame.width / 3
        /// 正方形で返す
        return CGSize(width: cellSize, height: cellSize)
    }
}
