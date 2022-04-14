/*
 編集画面の表示データモデル
 */

import Foundation

struct EditModel {
    
    var contentTitle: String
    var contentImageURL: URL?
    var videoLabel: String
    
    init() {
        contentTitle = "コンテンツ名"
        contentImageURL = nil
        videoLabel = "動画を追加"
    }
    
    mutating func setTitle(_ text: String) {
        contentTitle = text
    }
    
    mutating func setVideoLabel(_ text: String) {
        videoLabel = text
    }
    
    mutating func setImageURL(_ url: URL) {
        contentImageURL = url
    }
}
