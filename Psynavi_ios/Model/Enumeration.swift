/*
 作成した列挙型
 */

enum EditMode {
    case add
    case modify
}

enum PostMode {
    case inquiry
    case comment
}

enum RealmModel {
    case favorite
    case content
    case event
    case notice
    case map
}

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
    case uploadError
    case fetchError
    case syncDataError
    case deleteError
    case releaseError
    case userCreateError
    case userSignInError
    case userDisplayNameError
    
    var description: String {
        switch self {
        case .postError: return "送信に失敗"
        case .uploadError: return "保存に失敗しました"
        case .fetchError: return "データの受信に失敗しました"
        case .syncDataError: return "データの同期に失敗！再度お試しください"
        case .deleteError: return "削除に失敗しました。再度お試しください"
        case .releaseError: return "公開に失敗しました"
        case .userCreateError: return "ユーザー作成に失敗しました"
        case .userSignInError: return "ログインに失敗しました"
        case .userDisplayNameError: return "アカウント名の登録に失敗しました"
        }
    }
}
