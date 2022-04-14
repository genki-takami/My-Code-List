/*
 編集画面の表示データモデル
 */

import UIKit

struct EditModel {
    
    var eventTitle: String
    var eventImageBox: [EventImage]
    var eventImageCaptions: [String]
    var videoLabel: String
    
    init() {
        eventTitle = "イベント名"
        eventImageBox = [EventImage]()
        eventImageCaptions = [String]()
        videoLabel = "動画を追加"
    }
    
    mutating func setTitle(_ text: String) {
        eventTitle = text
    }
    
    mutating func setVideoLabel(_ text: String) {
        videoLabel = text
    }
    
    mutating func setImageCaption(_ captions: [String]) {
        eventImageCaptions = captions
    }
    
    mutating func setImageBox(_ box: [EventImage]) {
        eventImageBox = box
    }
    
    mutating func addImage(_ image: UIImage) {
        let box = EventImage(isNewImage: true, downloadImage: nil, uploadImage: image)
        eventImageBox.append(box)
    }
    
    mutating func addCaption(_ text: String) {
        let id = String(UUID().uuidString.prefix(10))
        let caption = id + text
        eventImageCaptions.append(caption)
    }
    
    mutating func removeImage(_ imageBox: EventImage) {
        let index: Int = eventImageBox.firstIndex(where: { $0.id == imageBox.id })!
        eventImageCaptions.remove(at: index)
        eventImageBox.remove(at: index)
    }
    
    func getCaption(_ imageBox: EventImage) -> String {
        let index: Int = eventImageBox.firstIndex(where: { $0.id == imageBox.id })!
        return eventImageCaptions[index]
    }
}
