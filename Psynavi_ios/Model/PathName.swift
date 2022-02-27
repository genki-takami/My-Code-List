/*
 アクセスするデータサーバーのコレクション/ドキュメント/画像のパス
 */

struct PathName {
    /// Firestore collection and document path
    static let FestivalPath = "campus-festival"
    static let DraftPath = "draft-festival"
    static let InquiryPath = "inquiry"
    static let ListContentsID = "CONTENTS"
    static let ListNoticeID = "NOTICE"
    static let ListCommentID = "COMMENT"
    static let ListEventsID = "EVENTS"
    static let ListMapID = "MAP"
    static let CatalogPath = "catalog"
    static let ReceiptPah = "receipts"
    
    
    /// Storage file and folder path
    static let ContentImagePath = "content-image"
    static let EventImagePath = "event-image"
    static let ContentVideoPath = "content-video"
    static let EventVideoPath = "event-video"
    static let FestivalBackgroundImagePath = "festival-background-image.jpg"
    static let FestivalIconImagePath = "festival-icon.jpg"
}
