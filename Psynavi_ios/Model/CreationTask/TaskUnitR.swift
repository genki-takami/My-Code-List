/*
 EditMainViewControllerの拡張
 */

import UIKit
import RealmSwift

extension EditMainViewController {
    
    // アプリ一時保存したデータを削除する
    func deleteRealmDatabase(){
        
        let contents = (DataProcessing.findAll(RealmModel.content) as! Results<ShopDisplay>).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        let events = (DataProcessing.findAll(RealmModel.event) as! Results<Event>).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        let notices = (DataProcessing.findAll(RealmModel.notice) as! Results<Notices>).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        let markers = (DataProcessing.findAll(RealmModel.map) as! Results<Map>).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        
        contents.forEach {
            DataProcessing.delete($0, RealmModel.content) { result in
                switch result {
                case .success(let text):
                    //
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
        
        events.forEach {
            DataProcessing.delete($0, RealmModel.event) { result in
                switch result {
                case .success(let text):
                    //
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
        
        notices.forEach {
            DataProcessing.delete($0, RealmModel.notice) { result in
                switch result {
                case .success(let text):
                    //
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
        
        markers.forEach {
            DataProcessing.delete($0, RealmModel.map) { result in
                switch result {
                case .success(let text):
                    //
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
}
