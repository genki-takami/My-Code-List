/*
 お気に入りタブの処理
 */

import UIKit
import RealmSwift

final class FavoriteTabViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var favoriteList: UITableView!
    var favorites = [Favorite]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteList.delegate = self
        favoriteList.dataSource = self
        
        setupView()
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // お気に入りデータを参照
        favorites.removeAll()
        let data = RealmTask.findAll(RealmModel.favorite) as! Results<Favorite>
        data.forEach {
            favorites.append($0)
        }
        
        favoriteList.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewFromFavoriteSegue" {
            let MainVC = segue.destination as! MainViewController
            MainVC.uuid = favorites[(sender as! IndexPath).row].id
        }
    }
}
