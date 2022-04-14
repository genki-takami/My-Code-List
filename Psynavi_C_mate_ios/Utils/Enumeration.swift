/*
 作成した列挙型
 */

enum FirebaseError: Error, CustomStringConvertible {
    case uploadError
    case fetchError
    case downloadError
    case videoDownloadError
    case videoUploadError
    case imageUploadError
    case existError
    case userSignInError
    
    var description: String {
        switch self {
        case .uploadError: return "保存に失敗しました"
        case .fetchError: return "データの受信に失敗\nIDが間違っていないことを確認してください"
        case .downloadError: return "画像のダウンロードに失敗しました"
        case .videoDownloadError: return "動画のダウンロードに失敗しました"
        case .videoUploadError: return "動画のアップロードに失敗しました。再度お試しください！"
        case .imageUploadError: return "画像のアップロードに失敗しました。再度お試しください！"
        case .existError: return "コンテンツ未登録か、IDが不正です"
        case .userSignInError: return "アクティベートに失敗しました"
        }
    }
}

enum FileTaskError: Error, CustomStringConvertible {
    case copyError
    case typeError
    case lengthError
    case sessionError
    case deleteError
    case cancelError
    case unknown
    
    var description: String {
        switch self {
        case .copyError: return "エラーが発生！再度試して下さい"
        case .typeError: return "データタイプが不正です"
        case .lengthError: return "動画の長さを15秒以内にして下さい"
        case .sessionError: return "処理中にエラーが発生しました"
        case .deleteError: return "動画を保存できませんでした"
        case .cancelError: return "処理がキャンセルされました！再度試して下さい"
        case .unknown: return "処理が完了しませんでした"
        }
    }
}

enum FocusedFields: Hashable {
    case uid
    case manager
    case date
    case place
    case tag
    case info
    case managerInfo
}
