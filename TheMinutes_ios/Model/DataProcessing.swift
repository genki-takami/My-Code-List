/*
 データ処理
 */

import Foundation
import RealmSwift

typealias ResultHandler<T> = (Result<T, Error>) -> Void

final class DataProcessing {
    
    static let realm = try! Realm()
    
    static func findAll(_ model: RealmModel) -> Any {
        switch model {
        case .folder:
            return realm.objects(Folder.self)
        case .minute:
            return realm.objects(Minute.self)
        case .place:
            return realm.objects(Place.self)
        case .attendee:
            return realm.objects(Attendee.self)
        }
    }
    
    static func add<T>(_ object: T, _ data: [String:Any], _ mode: EditMode, _ model: RealmModel, handler: @escaping ResultHandler<String>) {
        do {
            try realm.write {
                switch mode {
                case .add:
                    switch model {
                    case .folder:
                        realm.add(object as! Folder, update: .modified)
                    case .minute:
                        realm.add(object as! Minute, update: .modified)
                    case .place:
                        realm.add(object as! Place, update: .modified)
                    case .attendee:
                        realm.add(object as! Attendee, update: .modified)
                    }
                case .modifyFolder:
                    let folder = object as! Folder
                    folder.folderName = data["newFolderName"] as! String
                    realm.add(folder, update: .modified)
                case .modifyMinute:
                    let minute = object as! Minute
                    minute.meetingName = data["meetingName"] as! String
                    minute.secretary = data["secretary"] as! String
                    minute.topic = data["topic"] as! String
                    minute.date = data["date"] as! Date
                    minute.place = data["place"] as! String
                    minute.attendee = data["attendee"] as! String
                    minute.meetingContents = data["meetingContents"] as! String
                    minute.decision = data["decision"] as! String
                    minute.note = data["note"] as! String
                    realm.add(minute, update: .modified)
                }
            }
            handler(.success("保存しました"))
        } catch _ {
            handler(.failure(RealmError.saveError))
        }
    }
    
    static func delete<T>(_ object: T, _ model: RealmModel, handler: @escaping ResultHandler<String>) {
        do {
            try realm.write {
                switch model {
                case .folder: realm.delete(object as! Folder)
                case .minute: realm.delete(object as! Minute)
                case .place: realm.delete(object as! Place)
                case .attendee: realm.delete(object as! Attendee)
                }
            }
            handler(.success("削除しました"))
        } catch _ {
            handler(.failure(RealmError.deleteError))
        }
    }
}
