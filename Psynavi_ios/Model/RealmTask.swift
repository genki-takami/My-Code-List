/*
 Realmの処理
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
        case .favorite: return realm.objects(Favorite.self)
        case .content: return realm.objects(ShopDisplay.self)
        case .event: return realm.objects(Event.self)
        case .notice: return realm.objects(Notices.self)
        case .map: return realm.objects(Map.self)
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
                    case .favorite: realm.add(object as! Favorite, update: .modified)
                    case .content: realm.add(object as! ShopDisplay, update: .modified)
                    case .event: realm.add(object as! Event, update: .modified)
                    case .notice: realm.add(object as! Notices, update: .modified)
                    case .map: realm.add(object as! Map, update: .modified)
                    }
                case .modify:
                    switch model {
                    case .map:
                        let festivalData = object as! Map
                        festivalData.latitude = data["latitude"] as! Double
                        festivalData.longitude = data["longitude"] as! Double
                        festivalData.annotations.removeAll()
                        for i in (data["pinList"] as! [(String,String,String,Double,Double)]) {
                            let myAnnotation = Annotation()
                            myAnnotation.title = i.0
                            myAnnotation.subtitle = i.1
                            myAnnotation.pinImage = i.2
                            myAnnotation.latitude = i.3
                            myAnnotation.longitude = i.4
                            festivalData.annotations.append(myAnnotation)
                        }
                        realm.add(festivalData, update: .modified)
                    case .content:
                        let content = object as! ShopDisplay
                        content.name = data["name"] as! String
                        content.switchFlag = data["switchFlag"] as! Bool
                        content.manager = data["manager"] as! String
                        content.date = data["date"] as! String
                        content.place = data["place"] as! String
                        content.image = data["image"] as! Data
                        content.tag = data["tag"] as! String
                        content.info = data["info"] as! String
                        content.managerInfo = data["managerInfo"] as! String
                        realm.add(content, update: .modified)
                    case .notice:
                        let notice = object as! Notices
                        notice.noticeTitle = data["noticeTitle"] as! String
                        notice.noticeContent = data["noticeContent"] as! String
                        notice.date = data["date"] as! Date
                        realm.add(notice, update: .modified)
                    case .event:
                        let event = object as! Event
                        if data.keys.contains("imageProcess") {
                            event.images.append(data["imageData"] as! Data)
                            event.imageCaptions.append(data["captionData"] as! String)
                        } else if data.keys.contains("deleteProcess") {
                            event.images.remove(at: data["index"] as! Int)
                            event.imageCaptions.remove(at: data["index"] as! Int)
                        } else {
                            event.eventTitle = data["eventTitle"]  as! String
                            event.caption = data["caption"]  as! String
                            event.eventDate = data["eventDate"]  as! String
                            realm.add(event, update: .modified)
                        }
                    default:
                        break
                    }
                }
            }
            handler(.success("保存しました"))
        } catch _ {
            switch model {
            case .favorite: handler(.failure(RealmError.register))
            default: handler(.failure(RealmError.saveError))
            }
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
}
