/*
 列挙型
 */

import Foundation

enum RealmError: Error, CustomStringConvertible {
    case saveError
    case deleteError
    case register
    case disregister
    var description: String {
        switch self {
        case .saveError: return "保存に失敗にました！"
        case .deleteError: return "削除失敗！再度お試しください"
        case .register: return "お気に入り登録ができませんでした"
        case .disregister: return "お気に入り解除ができませんでした"
        }
    }
}

enum FirebaseError: Error, CustomStringConvertible {
    case postError
    case fetchError
    case deleteError
    var description: String {
        switch self {
        case .postError: return "送信に失敗"
        case .fetchError: return "データの受信に失敗しました"
        case .deleteError: return "削除に失敗しました。再度お試しください"
        }
    }
}

enum RealmModel {
    case favorite
}

enum EditMode {
    case add
}

enum PostMode {
    case inquiry
}
