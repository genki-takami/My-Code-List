/*
 MapViewControllerの拡張
 */

import MapKit

extension MapViewController: CLLocationManagerDelegate {
    
    /// UIのセットアップ
    func setupView() {
        setUpLocationManager()
        setUpRegion()
        setPins()
    }
    
    /// ロケーションマネージャーのセットアップ
    private func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
    }
    
    /// リージョンをセット
    private func setUpRegion() {
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        mapView.region = MKCoordinateRegion(center: center, span: span)
    }
    
    /// ピンをマップ上に設置
    private func setPins() {
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
}
