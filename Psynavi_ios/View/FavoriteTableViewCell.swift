/*
 お気に入りタブの処理
 */

import UIKit
import FirebaseUI

class FavoriteTableViewCell: UITableViewCell {
    
    // 変数
    @IBOutlet weak var festivalName:UILabel!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var school:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // FirebaseDataの内容をセルに表示
    func setData(_ data:RealmData){
        // 文化祭名・日付・開催場所
        self.festivalName.text = "\(data.festivalName)"
        self.date.text = "\(data.festivalDate)"
        self.school.text = "\(data.festivalPlace)"
    }
}
