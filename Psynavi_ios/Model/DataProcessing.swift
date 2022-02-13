/*
 データ処理
 */

import Foundation
import RealmSwift

final class DataProcessing {
    
    static let realm = try! Realm()

    static func findAll(_ model: RealmModel) -> Any {
        switch model {
        case .favorite:
            return realm.objects(Favorite.self)
        case .content:
            return realm.objects(ShopDisplay.self)
        case .event:
            return realm.objects(Event.self)
        case .notice:
            return realm.objects(Notices.self)
        case .map:
            return realm.objects(Map.self)
        }
    }

    static func add<T>(_ object: T, _ data: [String:Any], _ mode: EditMode, _ model: RealmModel, handler: @escaping ResultHandler<String>) {
        do {
            try realm.write {
                switch mode {
                case .add:
                    switch model {
                    case .favorite:
                        realm.add(object as! Favorite, update: .modified)
                    case .content:
                        realm.add(object as! ShopDisplay, update: .modified)
                    case .event:
                        realm.add(object as! Event, update: .modified)
                    case .notice:
                        realm.add(object as! Notices, update: .modified)
                    case .map:
                        realm.add(object as! Map, update: .modified)
                    }
                }
            }
            handler(.success("保存しました"))
        } catch _ {
            switch model {
            case .favorite:
                handler(.failure(RealmError.register))
            default:
                handler(.failure(RealmError.saveError))
            }
        }
    }

    static func delete<T>(_ object: T, _ model: RealmModel, handler: @escaping ResultHandler<String>) {
        do {
            try realm.write {
                switch model {
                case .favorite: realm.delete(object as! Favorite)
                case .content: realm.delete(object as! ShopDisplay)
                case .event: realm.delete(object as! Event)
                case .notice: realm.delete(object as! Notices)
                case .map: realm.delete(object as! Map)
                }
            }
            handler(.success("削除しました"))
        } catch _ {
            switch model {
            case .favorite: handler(.failure(RealmError.disregister))
            default: handler(.failure(RealmError.deleteError))
            }
        }
    }
    
    static func getUserData(_ key: String) -> String? {
       return UserDefaults.standard.string(forKey: key)
    }
    
    static func setUserData(_ value: String, _ key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    static func getPersonalData(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func setPersonalData(_ value: Bool, _ key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    static func getAccountData(_ key: String) -> [String]? {
        return UserDefaults.standard.stringArray(forKey: key)
    }
    
    static func setAccountData(_ value: [String], _ key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
}
