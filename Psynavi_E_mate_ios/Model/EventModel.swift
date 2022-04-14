/*
 企画イベントのデータモデル
 */

import UIKit

struct EventModel {
    let documentID: String
    let uid: String
    let eventTitle: String
    let eventDate: String
    let caption: String
    let imageCaptions: [String]
    let upgrade: Bool
    let video: Bool
    let imageBox: [EventImage]
}

struct EventImage: Identifiable {
    let id = UUID()
    let isNewImage: Bool
    var downloadImage: DownloadImageBox?
    var uploadImage: UIImage?
}
