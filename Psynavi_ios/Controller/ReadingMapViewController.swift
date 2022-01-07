/*
 公開オブジェクトのマップ表示処理
 */

import UIKit
import MapKit
import CoreLocation
import SafariServices
import SVProgressHUD

class ReadingMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // 変数
    @IBOutlet weak var mapView: MKMapView!
    var latitude, longitude: Double!
    var data: [String : Any]!
    var locationManager: CLLocationManager!
    var mapFileUrl: String!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート
        mapView.delegate = self
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        // リージョンをセット
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(self.latitude, self.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        // ピンをマップ上に設置
        let pinList: [String] = data!["list"] as! [String]
        for i in pinList{
            let thisOne = data![i] as! [String : Any]
            let pinLat = thisOne["latitude"] as! Double
            let pinLon = thisOne["longitude"] as! Double
            let pin = MapAnnotationSetting()
            pin.coordinate = CLLocationCoordinate2DMake(pinLat, pinLon)
            pin.title = thisOne["title"] as? String
            pin.subtitle = thisOne["subtitle"] as? String
            pin.pinImage = UIImage(named: (thisOne["pinImage"] as! String))
            self.mapView.addAnnotation(pin)
        }
    }
    
    // マップの種類を変更
    @IBAction func changeMapType(_ sender: Any) {
        if self.mapView.mapType == .standard{
            self.mapView.mapType = MKMapType.hybrid// 衛星マップ
        }else if self.mapView.mapType == .hybrid{
            self.mapView.mapType = MKMapType.standard// ２Dマップ
        }
    }
    
    // 案内マップファイルをブラウズ
    @IBAction func viewMapFile(_ sender: Any) {
        if let jumpLink = self.mapFileUrl{
            if jumpLink.isEmpty {
                SVProgressHUD.showError(withStatus: "登録されていません")
            } else {
                // Safariで開く
                guard let url = URL(string: jumpLink) else { return }
                present(SFSafariViewController(url: url), animated: true, completion: nil)
            }
        }
    }
    
    // ピンのレイアウトを返す
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 自分の現在地は置き換えない
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "pin"
        var annotationView: MKAnnotationView!

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
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
        
        annotationView.annotation = annotation
        annotationView.canShowCallout = true// ピンをタップした時の吹き出しの表示

        return annotationView
    }
}
