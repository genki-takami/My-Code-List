/*
 多用するであろう文字列を格納する構造体ファイル
 */

import Foundation

struct PathName {
    // Firestore Collection Path
    static let FestivalPath = "campus-festival"
    static let DraftPath = "draft-festival"
    static let InquiryPath = "inquiry"
    static let ListContentsID = "CONTENTS"
    static let ListNoticeID = "NOTICE"
    static let ListCommentID = "COMMENT"
    static let ListEventsID = "EVENTS"
    static let ListMapID = "MAP"
    static let CatalogPath = "catalog"
    
    
    // Storage File & Folder Path
    static let ContentImagePath = "content-image"
    static let EventImagePath = "event-image"
    static let FestivalBackgroundImagePath = "festival-background-image.jpg"
    static let FestivalIconImagePath = "festival-icon"
}
