/*
 ホームタブのセルの処理
 */

import UIKit
import FirebaseUI

class HomeTableViewCell: UITableViewCell {
    
    // 変数
    @IBOutlet weak var festivalName:UILabel!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var place:UILabel!
    @IBOutlet weak var festivalImage:UIImageView!
    @IBOutlet weak var favoriteButton:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // FirebaseDataの内容をセルに表示
    func setFirebaseData(_ firebaseData:FirebaseData){
        // 画像の表示
        festivalImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        festivalImage.sd_setImage(with: Storage.storage().reference().child(firebaseData.uuid).child(Const.FestivalBackgroundImagePath + ".jpg"))
        
        // 文化祭名・日付・開催場所の表示
        self.festivalName.text = "\(firebaseData.festivalName)"
        self.date.text = "\(firebaseData.date)"
        self.place.text = "\(firebaseData.place)"
        
        // お気に入り判定
        firebaseData.isFavorite ? self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
}
