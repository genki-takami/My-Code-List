/*
 EditMapViewControllerの拡張
 */

import MapKit

extension EditMapViewController: CLLocationManagerDelegate {
    
    /// UIのセットアップ
    func setupView() {
        
        setUpLocationManager()
        setUpRegion()
        setDismissKeyboard()
    }
    
    /// ロケーションマネージャーのセットアップ
    private func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    /// マップの中心を設定
    private func setUpRegion() {
        
        let defaultCenter = CLLocationCoordinate2DMake(35.681236, 139.767125)
        let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let defaultRegion = MKCoordinateRegion(center: defaultCenter, span: defaultSpan)
        
        if let _ = festivalData {
            /// 座標が編集済み
            if festivalData.latitude == doubleLat && festivalData.longitude == doubleLon {
                /// リージョンが未保存の場合、初期値は東京駅の位置情報をセット
                mapView.region = defaultRegion
            } else {
                /// 保存されている場合はリージョンをセット
                doubleLat = festivalData.latitude
                latitude.text = "\(doubleLat)"
                doubleLon = festivalData.longitude
                longitude.text = "\(doubleLon)"
                
                let center = CLLocationCoordinate2DMake(doubleLat, doubleLon)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                mapView.region = MKCoordinateRegion(center: center, span: span)
            }
        } else {
            /// 新規作成、初期値は東京駅の位置情報をセット
            mapView.region = defaultRegion
            createNewMapData()
        }
    }
}
