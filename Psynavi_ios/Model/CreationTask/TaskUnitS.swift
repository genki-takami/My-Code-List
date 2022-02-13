/*
 EditMapViewControllerの拡張
 */

import UIKit
import MapKit

extension EditMapViewController: CLLocationManagerDelegate, UIViewControllerTransitioningDelegate, DataReturn2 {
    
    func createNewMapData() {
        festivalData = Map()
        festivalData.mailAdress = mailAdress
        festivalData.password = password
    }
    
    // マップの起動準備
    func setUpMaps() {
        setUpLocationManager()
        setUpRegion()
    }
    
    // ロケーションマネージャーのセットアップ
    private func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    // 中心座標を変更
    func shiftRegion() {
        
        if let lat = latitude.text, let lon = longitude.text {
            
            if lat.isEmpty || lon.isEmpty {
                DisplayPop.error("緯度経度を記入してください！")
            } else {
                doubleLat = Double(lat)!
                doubleLon = Double(lon)!
                
                let center = CLLocationCoordinate2DMake(doubleLat, doubleLon)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                mapView.region = MKCoordinateRegion(center: center, span: span)
            }
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
    
    // マップピンの追加
    func addPin(_ sender: UILongPressGestureRecognizer) {
        // ロングタップの最初の感知のみ受け取る
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        pin = MapAnnotationSetting()
        // ロングタップした位置情報を取得
        let location: CGPoint = sender.location(in: mapView)
        // 取得した位置情報をCLLocationCoordinate2D（座標）に変換
        let coordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        // 座標をピンに設定
        pin.coordinate = coordinate
        
        // 詳細設定に行く
        let pinEditViewController = self.storyboard?.instantiateViewController(withIdentifier: "PinEditView") as! EditMapPinViewController
        pinEditViewController.modalPresentationStyle = .custom
        pinEditViewController.transitioningDelegate = self
        pinEditViewController.delegate = self
        
        present(pinEditViewController, animated: true, completion: nil)
    }
    
    // 受け取ったデータでピンを表示
    func returnData2(titleData: String, subtitleData: String, imageData: String) {
                
        pin.title = titleData
        pin.subtitle = subtitleData
        pin.pinImage = UIImage(named: imageData)
        let pinLat: Double = pin.coordinate.latitude
        let pinLon: Double = pin.coordinate.longitude
        let package: (String,String,String,Double,Double) = (titleData,subtitleData,imageData,pinLat,pinLon)
        pinList.append(package)
        
        mapView.addAnnotation(pin)
        DisplayPop.success("ピンを追加しました！")
    }
}
