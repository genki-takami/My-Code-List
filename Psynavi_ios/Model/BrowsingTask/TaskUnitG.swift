/*
 MapViewControllerの拡張
 */

import UIKit
import MapKit
import SafariServices

extension MapViewController: CLLocationManagerDelegate {
    
    // マップの起動準備
    func setUpMaps() {
        setUpLocationManager()
        setUpRegion()
        setPins()
    }
    
    // ロケーションマネージャーのセットアップ
    private func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
    }
    
    // 案内マップファイルをブラウズ
    func browsingMapFile() {
        
        if let jumpLink = mapFileUrl {
            
            if jumpLink.isEmpty {
                DisplayPop.error("登録されていません")
            } else {
                guard let url = URL(string: jumpLink) else { return }
                present(SFSafariViewController(url: url), animated: true, completion: nil)
            }
        }
    }
}
