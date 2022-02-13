/*
 EditMapViewControllerの拡張
 */

import UIKit
import MapKit

extension EditMapViewController: MKMapViewDelegate {
    
    // ピンの表示をレイアウト
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 自分の現在地は置き換えない
        if annotation is MKUserLocation {
            return nil
        }

        var annotationView: MKAnnotationView!

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }

        // ピンにセットした画像をつける
        if let pin = annotation as? MapAnnotationSetting {
            if let pinImage = pin.pinImage {
                // ピンのサイズを縫製
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
        
        // 削除ボタンの設置
        let btn = UIButton()
        btn.frame = CGRect(x:0,y:0,width:40,height:40)
        btn.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        btn.tintColor = UIColor.red
        btn.setTitle("", for: .normal)
        annotationView.rightCalloutAccessoryView = btn

        return annotationView
    }
    
    // ピンの吹き出しの削除ボタン
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let thisOne = view.annotation
        // 画面表示から削除
        self.mapView.removeAnnotation(thisOne!)
        // ピンのリストから削除
        for (index, pin) in pinList.enumerated() {
            if pin.0 == thisOne?.title && pin.1 == thisOne?.subtitle {
                pinList.remove(at: index)
                break
            }
        }
        DisplayPop.success("ピンを削除しました")
    }
    
    // マップをタッチした時の処理を返す
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // NONE
    }
}
