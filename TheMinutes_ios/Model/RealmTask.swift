/*
 データ処理
 */

import RealmSwift

final class RealmTask {
    
    /// Realm instance
    static let realm = try! Realm()
    
    /// - Parameters:
    ///   - model:      The given type stored in the Realm.
    /// - Returns:      All objects of the given type stored in the Realm.
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
    
    /// - Parameters:
    ///   - object:     The object to be added or modified to this Realm.
    ///   - data:       The data to modify each object paramerters.
    ///   - mode:       The type of save process is add or modify
    ///   - model:      The given type stored in the Realm.
    /// - Returns:      If it succeeds, it returns that fact, and if it fails, it returns the error content.
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
    
    /// - Parameters:
    ///   - object:     The object to be deleted.
    ///   - model:      The given type stored in the Realm.
    /// - Returns:      If it succeeds, it returns that fact, and if it fails, it returns the error content.
    static func delete<T>(_ object: T, _ model: RealmModel, handler: @escaping ResultHandler<String>) {
        do {
            try realm.write {
                switch model {
                case .folder:
                    let folder = object as! Folder
                    let id = folder.id
                    
                    /// フォルダー下のデータも削除
                    (RealmTask.findAll(RealmModel.minute) as! Results<Minute>).filter("folderId == %@", id).forEach {
                        realm.delete($0)
                    }
                    (RealmTask.findAll(RealmModel.place) as! Results<Place>).filter("folderId == %@", id).forEach {
                        realm.delete($0)
                    }
                    (RealmTask.findAll(RealmModel.attendee) as! Results<Attendee>).filter("folderId == %@", id).forEach {
                        realm.delete($0)
                    }
                    
                    realm.delete(folder)
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
