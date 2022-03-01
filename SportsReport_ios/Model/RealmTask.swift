/*
 データ処理
 */

import RealmSwift

final class RealmTask {
    
    /// Realm instance
    private static let realm = try! Realm()
    
    /// - Returns:      All objects of the given type stored in the Realm.
    static func findAll() -> Results<Report> {
        realm.objects(Report.self)
    }
    
    /// - Parameters:
    ///   - report:     The object to be added or modified to this Realm.
    ///   - draft:      The data to modify each object paramerters.
    /// - Returns:      If it succeeds, it returns that fact, and if it fails, it returns the error content.
    static func add(_ report: Report, _ draft: [String : Any], handler: @escaping ResultHandler<String>) {
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
    
    /// - Parameters:
    ///   - report:     The object to be deleted.
    /// - Returns:      If it succeeds, it returns that fact, and if it fails, it returns the error content.
    static func delete(_ report: Report, handler: @escaping ResultHandler<String>) {
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
