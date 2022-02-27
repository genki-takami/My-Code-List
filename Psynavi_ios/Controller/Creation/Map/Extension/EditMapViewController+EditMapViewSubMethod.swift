/*
 EditMapViewControllerの拡張
 */

import MapKit

extension EditMapViewController: EditMapViewSubMethod, UIViewControllerTransitioningDelegate {
    
    /// 新規マップデータの作成
    func createNewMapData() {
        festivalData = Map()
        festivalData.mailAdress = mailAdress
        festivalData.password = password
    }
    
    /// 中心座標を変更
    func shiftRegion() {
        
        guard let lat = latitude.text, let lon = longitude.text else { return }
        
        if lat.isEmpty || lon.isEmpty {
            Modal.showError("緯度経度を記入してください！")
        } else {
            doubleLat = Double(lat)!
            doubleLon = Double(lon)!
            
            let center = CLLocationCoordinate2DMake(doubleLat, doubleLon)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            mapView.region = MKCoordinateRegion(center: center, span: span)
        }
    }
    
    /// マップの種類を変更
    func shiftMapType() {
        if mapView.mapType == .standard {
            /// 衛星マップ
            mapView.mapType = MKMapType.hybrid
        } else if mapView.mapType == .hybrid {
            /// ２Dマップ
            mapView.mapType = MKMapType.standard
        }
    }
    
    /// マップピンの追加
    func addPin(_ sender: UILongPressGestureRecognizer) {
        /// ロングタップの最初の感知のみ受け取る
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        pin = MapAnnotationSetting()
        /// ロングタップした位置情報を取得
        let location: CGPoint = sender.location(in: mapView)
        /// 取得した位置情報をCLLocationCoordinate2D（座標）に変換
        let coordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        /// 座標をピンに設定
        pin.coordinate = coordinate
        
        /// 詳細設定に行く
        let pinEditViewController = self.storyboard?.instantiateViewController(withIdentifier: "PinEditView") as! EditMapPinViewController
        pinEditViewController.modalPresentationStyle = .custom
        pinEditViewController.transitioningDelegate = self
        pinEditViewController.delegate = self
        
        present(pinEditViewController, animated: true, completion: nil)
    }
    
    /// マップピン編集のポップアップ
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension EditMapViewController: DataReturn2 {
    
    /// 受け取ったデータでピンを表示
    func returnData2(titleData: String, subtitleData: String, imageData: String) {
                
        pin.title = titleData
        pin.subtitle = subtitleData
        pin.pinImage = UIImage(named: imageData)
        let pinLat: Double = pin.coordinate.latitude
        let pinLon: Double = pin.coordinate.longitude
        let package: (String,String,String,Double,Double) = (titleData,subtitleData,imageData,pinLat,pinLon)
        pinList.append(package)
        
        mapView.addAnnotation(pin)
        Modal.showSuccess("ピンを追加しました！")
    }
}
