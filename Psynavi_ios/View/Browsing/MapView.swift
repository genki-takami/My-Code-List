/*
 MapViewControllerの拡張
 */

import UIKit
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    // リージョンをセット
    func setUpRegion() {
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        mapView.region = MKCoordinateRegion(center: center, span: span)
    }
    
    // ピンをマップ上に設置
    func setPins() {
        let pinList: [String] = data!["list"] as! [String]
        
        for pin in pinList {
            let dataPayload = data![pin] as! [String : Any]
            let pinLat = dataPayload["latitude"] as! Double
            let pinLon = dataPayload["longitude"] as! Double
            
            let pin = MapAnnotationSetting()
            pin.coordinate = CLLocationCoordinate2DMake(pinLat, pinLon)
            pin.title = dataPayload["title"] as? String
            pin.subtitle = dataPayload["subtitle"] as? String
            pin.pinImage = UIImage(named: (dataPayload["pinImage"] as! String))
            
            mapView.addAnnotation(pin)
        }
    }
    
    // マップの種類を変更
    func shiftMapType() {
        
        if mapView.mapType == .standard {
            mapView.mapType = MKMapType.hybrid   // 衛星マップ
        } else if mapView.mapType == .hybrid {
            mapView.mapType = MKMapType.standard // ２Dマップ
        }
    }
    
    // ピンのレイアウトを返す
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 自分の現在地は置き換えない
        if annotation is MKUserLocation {
            return nil
        }

        var annotationView: MKAnnotationView!

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }

        // ピンに画像をセット
        if let pin = annotation as? MapAnnotationSetting {
            if let pinImage = pin.pinImage {
                // サイズを調整
                let size = CGSize(width: 50, height: 50)
                UIGraphicsBeginImageContext(size)
                pinImage.draw(in: CGRect(origin: .zero, size: size))
                annotationView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        // 注釈とピンをタップした時の吹き出しをセット
        annotationView.annotation = annotation
        annotationView.canShowCallout = true

        return annotationView
    }
}
