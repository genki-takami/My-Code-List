/*
 EditMainViewControllerの拡張
 */

import RealmSwift

extension EditMainViewController: DeleteTemporaryData {
    
    /// アプリ一時保存したデータを削除する
    func deleteTemporaryData() {
        
        let contents = (RealmTask.findAll(RealmModel.content) as! Results<ShopDisplay>).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        let events = (RealmTask.findAll(RealmModel.event) as! Results<Event>).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        let notices = (RealmTask.findAll(RealmModel.notice) as! Results<Notices>).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        let markers = (RealmTask.findAll(RealmModel.map) as! Results<Map>).filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        
        contents.forEach {
            RealmTask.delete($0, RealmModel.content) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
        
        events.forEach {
            RealmTask.delete($0, RealmModel.event) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
        
        notices.forEach {
            RealmTask.delete($0, RealmModel.notice) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
        
        markers.forEach {
            RealmTask.delete($0, RealmModel.map) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
