/*
 データ処理
 */

import Foundation
import RealmSwift

typealias ResultHandler<T> = (Result<T, Error>) -> Void

enum RealmError: Error, CustomStringConvertible {
    case saveError
    case deleteError
    var description: String {
        switch self {
        case .saveError: return "保存に失敗にました！"
        case .deleteError: return "削除失敗！再度お試しください"
        }
    }
}

final class DataProcessing {
    
    private static let realm = try! Realm()
    
    static func findAll() -> Results<Report> {
        realm.objects(Report.self)
    }
    
    static func add(_ report:Report, _ draft: [String : Any], handler: @escaping ResultHandler<String>) {
        do {
            try realm.write {
                report.injured = draft["injured"] as! String
                report.reporter = draft["reporter"] as! String
                report.date = draft["date"] as! Date
                report.spot = draft["spot"] as! String
                report.part = draft["part"] as! String
                report.diagnosis = draft["diagnosis"] as! String
                report.cause = draft["cause"] as! String
                report.aftereffect = draft["aftereffect"] as! String
                report.image = draft["picture"] as! Data
                realm.add(report, update: .modified)
            }
            handler(.success("保存しました"))
        } catch _ {
            handler(.failure(RealmError.saveError))
        }
    }
    
    static func delete(_ report:Report, handler: @escaping ResultHandler<String>) {
        do {
            try realm.write {
                realm.delete(report)
            }
            handler(.success("削除しました"))
        } catch _ {
            handler(.failure(RealmError.deleteError))
        }
    }
}
