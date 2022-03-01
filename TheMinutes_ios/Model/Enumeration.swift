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

enum RealmModel {
    case folder
    case minute
    case place
    case attendee
}

enum EditMode {
    case add
    case modifyFolder
    case modifyMinute
}
