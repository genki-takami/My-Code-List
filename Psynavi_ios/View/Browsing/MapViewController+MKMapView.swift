/*
 MapViewControllerの拡張
 */

import MapKit

extension MapViewController: MKMapViewDelegate {
    
    /// ピンのレイアウトを返す
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        /// 自分の現在地は置き換えない
        if annotation is MKUserLocation {
            return nil
        }

        var annotationView: MKAnnotationView!

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }

        /// ピンに画像をセット
        if let pin = annotation as? MapAnnotationSetting {
            if let pinImage = pin.pinImage {
                /// サイズを調整
                let size = CGSize(width: 50, height: 50)
                UIGraphicsBeginImageContext(size)
                pinImage.draw(in: CGRect(origin: .zero, size: size))
                annotationView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        /// 注釈とピンをタップした時の吹き出しをセット
        annotationView.annotation = annotation
        annotationView.canShowCallout = true

        return annotationView
    }
}
