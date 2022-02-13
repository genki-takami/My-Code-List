/*
 EditMainViewControllerの拡張
 */

import UIKit
import RealmSwift
import FirebaseFirestore

extension EditMainViewController {
    
    // MARK: - データを構築する
    func buildDocumentData(_ contents: Results<ShopDisplay>, _ notices: Results<Notices>, _ events: Results<Event>, _ mapData: Map) -> [Any] {
        
        // 各データを構築
        let content = buildContent(contents)
        let event = buildEvent(events)
        let notice = buildNotice(notices)
        let map = buildMap(mapData)
        
        // ドラフトデータ
        let mainData: [String: Any] = [
            "owner" :  accountName.text ?? "NO-NAME",
            "festivalName" : saveData.festivalName,
            "date" : saveData.date,
            "school" : saveData.school,
            "slogan" : saveData.slogan,
            "info" : saveData.info,
            "latitude" : mapData.latitude,
            "longitude" : mapData.longitude,
            "link" : [
                "title1" : saveData.title1,
                "url1" : saveData.url1,
                "title2" : saveData.title2,
                "url2" : saveData.url2,
            ],
            "database" : [
                "shop": content[0],
                "display": content[1],
                "contentImage": content[2],
                "event": event[0],
                "marker": map[0],
                "notice": notice[0] ,
                "eventImage": event[1],
                "icon" : saveData.uuid + "/" + PathName.FestivalIconImagePath,
                "background" : saveData.uuid + "/" + PathName.FestivalBackgroundImagePath,
            ],
            "upgrade" : UserDefaults.standard.bool(forKey: saveData.uuid),
        ]
        
        return [content[3], content[4], event[2], event[3], notice[1], notice[2], map[1], mainData]
    }
    
    // MARK: - コンテンツデータ
    private func buildContent(_ contents: Results<ShopDisplay>) -> [Any] {
        
        var shopCount = saveData.shop
        var displayCount = saveData.display
        var cImage = contentImage
        var contentsData = [String: Any]()
        var contentList = [String]()
        if !contents.isEmpty {
            for content in contents {
                let contentId = NSUUID().uuidString
                contentList.append(contentId)
                let data: [String: Any] = [
                    "switchFlag" : content.switchFlag,
                    "name" : content.name,
                    "manager" : content.manager,
                    "date" : content.date,
                    "place" : content.place,
                    "tag" : content.tag,
                    "info" : content.info,
                    "managerInfo" : content.managerInfo,
                ]
                contentsData[contentId] = data
                content.switchFlag ? (shopCount += 1) : (displayCount += 1)
                cImage.append("\(saveData.uuid)/\(PathName.ContentImagePath)/\(content.name).jpg")
            }
            if isNewObject {
                contentsData["list"] = contentList
            }
        }
        
        return [shopCount, displayCount, cImage, contentsData, contentList]
    }
    
    // MARK: - イベントデータ
    private func buildEvent(_ events: Results<Event>) -> [Any] {
        
        var eventCount = saveData.event
        var eImage = eventImage
        var eventsData = [String: Any]()
        var eventList = [String]()
        if !events.isEmpty {
            for event in events {
                // キャプションの配列を作成
                var captionList = [String]()
                for n in event.imageCaptions{
                    captionList.append(n)
                    eImage.append("\(saveData.uuid)/\(PathName.EventImagePath)/\(event.eventTitle)/\(n.prefix(10)).jpg")
                }
                let eventId = NSUUID().uuidString
                eventList.append(eventId)
                let data: [String: Any] = [
                    "eventTitle" : event.eventTitle,
                    "eventDate" : event.eventDate,
                    "caption" : event.caption,
                    "imageCaptions" : captionList,
                ]
                eventsData[eventId] = data
                eventCount += 1
            }
            if isNewObject {
                eventsData["list"] = eventList
            }
        }
        
        return [eventCount, eImage, eventsData, eventList]
    }
    
    // MARK: - お知らせデータ
    private func buildNotice(_ notices: Results<Notices>) -> [Any] {
        
        var noticeCount = saveData.notice
        var noticesData = [String: Any]()
        var noticeList = [String]()
        if !notices.isEmpty {
            for notice in notices {
                let noticeId = NSUUID().uuidString
                noticeList.append(noticeId)
                let data: [String: Any] = [
                    "noticeTitle" : notice.noticeTitle,
                    "noticeContent" : notice.noticeContent,
                    "date" : Timestamp(date: notice.date),
                ]
                noticesData[noticeId] = data
                noticeCount += 1
            }
            if isNewObject {
                noticesData["list"] = noticeList
            }
        }
        
        return [noticeCount, noticesData, noticeList]
    }
    
    // MARK: - マップデータ
    private func buildMap(_ mapData: Map) -> [Any] {
        
        var markerCount = saveData.marker
        var annotationData = [String: Any]()
        if !mapData.annotations.isEmpty {
            var pinList = [String]()
            for pin in mapData.annotations {
                let pinId = NSUUID().uuidString
                pinList.append(pinId)
                let data: [String: Any] = [
                    "title" : pin.title,
                    "subtitle" : pin.subtitle,
                    "pinImage" : pin.pinImage,
                    "latitude" : pin.latitude,
                    "longitude" : pin.longitude,
                ]
                annotationData[pinId] = data
                markerCount += 1
            }
            annotationData["list"] = pinList
        }
        
        return [markerCount, annotationData]
    }
}
