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
                    }
                }
            }
            handler(.success("保存しました"))
        } catch _ {
            switch model {
            case .favorite:
                handler(.failure(RealmError.register))
            }
        }
    }

    static func delete<T>(_ object: T, _ model: RealmModel, handler: @escaping ResultHandler<String>) {
        do {
            try realm.write {
                switch model {
                case .favorite: realm.delete(object as! Favorite)
                }
            }
            handler(.success("削除しました"))
        } catch _ {
            switch model {
            case .favorite:
                handler(.failure(RealmError.disregister))
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
}
