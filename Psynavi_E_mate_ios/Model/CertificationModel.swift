/*
 認証画面の表示データモデル
 */

import Foundation

struct CertificationModel {
    
    var statusText: String
    let annotationText: String
    var isFetched: Bool
    var activateFlag: Bool
    var data: EventModel?
    
    init() {
        statusText = "ステータス：編集不可"
        annotationText = Sentences.certificateAnnotation
        isFetched = false
        activateFlag = false
        data = nil
    }
    
    mutating func activate() {
        statusText = "ステータス：編集可能"
        activateFlag = true
    }
    
    mutating func fetchResult(is result : Bool) {
        isFetched = result
    }
    
    mutating func setData(with data: EventModel) {
        self.data = data
    }
    
    func checkActivate() -> Bool {
        if activateFlag {
            return true
        } else {
            return false
        }
    }
}
