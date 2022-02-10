/*
 公開オブジェクトのマップ表示処理
 */

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var mapView: MKMapView!
    var latitude, longitude: Double!
    var data: [String : Any]!
    var locationManager: CLLocationManager!
    var mapFileUrl: String!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        setUpMaps()
    }
    
    // MARK: - マップの種類を変更
    @IBAction private func changeMapType(_ sender: Any) {
        shiftMapType()
    }
    
    // MARK: - 案内マップファイルをブラウズ
    @IBAction private func viewMapFile(_ sender: Any) {
        browsingMapFile()
    }
}
