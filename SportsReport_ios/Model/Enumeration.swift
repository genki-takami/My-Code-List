/*
 列挙型
 */

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
