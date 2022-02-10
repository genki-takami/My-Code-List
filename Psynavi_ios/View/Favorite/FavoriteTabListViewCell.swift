/*
 お気に入りタブの処理
 */

import UIKit

final class FavoriteTabListViewCell: UITableViewCell {
    
    // 変数
    @IBOutlet private weak var festivalName: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var school: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ data:Favorite) {
        // 文化祭名・日付・開催場所をセット
        festivalName.text = "\(data.festivalName)"
        date.text = "\(data.festivalDate)"
        school.text = "\(data.festivalPlace)"
    }
}
