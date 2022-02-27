/*
 MapViewControllerの拡張
 */

import MapKit
import SafariServices

extension MapViewController: MapViewSubMethod {
    
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
    
    /// 案内マップファイルをブラウズ
    func browsingMapFile() {
        
        guard let jumpLink = mapFileUrl else { return }
        
        if jumpLink.isEmpty {
            Modal.showError("登録されていません")
        } else {
            guard let url = URL(string: jumpLink) else { return }
            present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
}
