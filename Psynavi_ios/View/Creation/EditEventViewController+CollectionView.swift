/*
 EditEventViewControllerの拡張
 */

import UIKit

extension EditEventViewController: UICollectionViewDelegate {
    
    /// セルをタップ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// イベント画像とキャプションを渡して画面遷移
        selectedImage = UIImage(data:event.images[indexPath.row])
        selectedCaption = event.imageCaptions[indexPath.row]
        if selectedImage != nil || selectedCaption != nil {
            performSegue(withIdentifier: "toImageShowCell",sender: nil)
        }
    }
}

extension EditEventViewController: UICollectionViewDataSource {
    
    /// セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return event.images.count
    }
    
    /// セルの内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        let imageView = imageCell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(data:event.images[indexPath.row])
        
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        imageCell.addGestureRecognizer(tapGesture)
        
        return imageCell
    }
    
    @objc func goToDetail(sender: MyTapGestureRecognizer){
        collectionView(imageCollection, didSelectItemAt: sender.indexValue!)
    }
}

extension EditEventViewController: UICollectionViewDelegateFlowLayout {
    
    /// セルのレイアウト
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// １行３セル
        let cellSize:CGFloat = self.view.frame.width / 3
        /// 正方形で返す
        return CGSize(width: cellSize, height: cellSize)
    }
}
