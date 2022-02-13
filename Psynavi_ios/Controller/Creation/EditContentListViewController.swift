/*
 編集オブジェクトのコンテンツリストの処理
 */

import UIKit
import RealmSwift

final class EditContentListViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var contentsTable: UITableView!
    var mailAdress, password: String!
    var contentsArray = [ShopDisplay]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentsTable.delegate = self
        contentsTable.dataSource = self
        contentsTable.tableFooterView = UIView()
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ショップと展示のデータを参照
        contentsArray.removeAll()
        let data = (DataProcessing.findAll(RealmModel.content) as! Results<ShopDisplay>)
                    .filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        data.forEach {
            contentsArray.append($0)
        }
        
        contentsTable.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "contentsCellSegue":
            let editContentVC = segue.destination as! EditContentViewController
            let indexPath = contentsTable.indexPathForSelectedRow
            editContentVC.content = contentsArray[indexPath!.row]
        case "editASegue":
            let editContentVC = segue.destination as! EditContentViewController
            
            let content = ShopDisplay()
            content.mailAdress = mailAdress
            content.password = password
            
            editContentVC.content = content
        default:
            break
        }
    }
}
