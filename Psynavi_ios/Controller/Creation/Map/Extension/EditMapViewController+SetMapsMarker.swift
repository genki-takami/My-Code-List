/*
 EditMapViewControllerの拡張
 */

import MapKit

extension EditMapViewController: SetMapsMarker {
    
    /// ローカルに保存されたアノテーションがあればマップに表示
    func setPins() {
        if !festivalData.annotations.isEmpty {
            
            for marker in festivalData.annotations {
                
                let pin = MapAnnotationSetting()
                pin.coordinate = CLLocationCoordinate2DMake(marker.latitude, marker.longitude)
                pin.title = marker.title
                pin.subtitle = marker.subtitle
                pin.pinImage = UIImage(named: marker.pinImage)
                let package: (String,String,String,Double,Double) = (marker.title,marker.subtitle,marker.pinImage,marker.latitude,marker.longitude)
                pinList.append(package)
                
                mapView.addAnnotation(pin)
            }
        }
    }
    
    /// クラウドデータにあるアノテーションがあればマップに表示
    func setPinsFromCloud() {
        
        guard let latitude = downloadLat, let longitude = downloadLon, let count = downloadableMarkers else { return }
        
        /// 座標を決める
        doubleLat = latitude
        self.latitude.text = "\(doubleLat)"
        doubleLon = longitude
        self.longitude.text = "\(doubleLon)"
        
        let center = CLLocationCoordinate2DMake(doubleLat, doubleLon)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.region = MKCoordinateRegion(center: center, span: span)
        
        /// Firestoreからフェッチ
        if count > 0 {
            
            Modal.show()
            
            FetchData.fetchDocument(PathName.ListMapID, uuid) { result in
                switch result {
                case .success(let data):
                    /// ピンをマップ上に設置
                    let markers: [String] = data["list"] as! [String]
                    for marker in markers {
                        let dataPayload = data[marker] as! [String : Any]
                        
                        let pinLat = dataPayload["latitude"] as! Double
                        let pinLon = dataPayload["longitude"] as! Double
                        
                        let pin = MapAnnotationSetting()
                        pin.coordinate = CLLocationCoordinate2DMake(pinLat, pinLon)
                        let pt = dataPayload["title"] as! String
                        pin.title = pt
                        let ps = dataPayload["subtitle"] as! String
                        pin.subtitle = ps
                        let image = dataPayload["pinImage"] as! String
                        pin.pinImage = UIImage(named: image)
                        
                        let package: (String,String,String,Double,Double) = (pt,ps,image,pinLat,pinLon)
                        self.pinList.append(package)
                        
                        Modal.dismiss()
                        self.mapView.addAnnotation(pin)
                    }
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
