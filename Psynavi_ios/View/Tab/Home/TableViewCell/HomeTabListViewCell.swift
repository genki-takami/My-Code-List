/*
 ホームタブのセルの処理
 */

import UIKit
import FirebaseStorageUI

final class HomeTabListViewCell: UITableViewCell {
    
    // 変数
    @IBOutlet private weak var festivalName:UILabel!
    @IBOutlet private weak var date:UILabel!
    @IBOutlet private weak var place:UILabel!
    @IBOutlet private weak var festivalImage:UIImageView!
    @IBOutlet weak var favoriteButton:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFirebaseData(_ firebaseData: HomeTabCellData) {
        
        // 画像の表示
        festivalImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let ref = FetchData.getStorageReference(firebaseData.uuid, PathName.FestivalBackgroundImagePath)
        festivalImage.sd_setImage(with: ref)
        
        // 文化祭名・日付・開催場所の表示
        festivalName.text = "\(firebaseData.festivalName)"
        date.text = "\(firebaseData.date)"
        place.text = "\(firebaseData.place)"
        
        // お気に入り判定
        if firebaseData.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
