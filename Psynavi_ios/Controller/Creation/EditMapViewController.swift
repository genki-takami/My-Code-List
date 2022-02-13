/*
 編集オブジェクトのマップの編集処理
 */

import UIKit
import MapKit

final class EditMapViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    var doubleLat = 35.681236, doubleLon = 139.767125
    let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(35.681236, 139.767125),
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var pin: MapAnnotationSetting!
    var uuid, mailAdress, password: String!
    var pinList = [(String,String,String,Double,Double)]()
    var festivalData: Map!
    var downloadLat, downloadLon: Double!
    var downloadableMarkers: Int!
    var locationManager: CLLocationManager!

    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
         
        mapView.delegate = self
        
        setUpMaps()
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setPins()
        setPinsFromCloud()
    }
    
    // MARK: - 緯度軽度でリージョンを変更
    @IBAction private func changeRegion(_ sender: Any) {
        shiftRegion()
    }
    
    // MARK: - マップの種類を変更
    @IBAction private func chageMapType(_ sender: Any) {
        shiftMapType()
    }
    
    // MARK: - ピンを追加する
    @IBAction private func longPressMap(_ sender: UILongPressGestureRecognizer) {
        addPin(sender)
    }
    
    // マップピン編集のポップアップ
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // MARK: - SAVE
    @IBAction private func savePin(_ sender: Any) {
        
        DisplayPop.show()
        
        let data: [String:Any] = [
            "latitude": doubleLat,
            "longitude": doubleLon,
            "pinList": pinList
        ]
        
        DataProcessing.add(festivalData, data, EditMode.modify, RealmModel.map) { result in
            switch result {
            case .success(_):
                DisplayPop.success("マップを保存しました")
            case .failure(let error):
                DisplayPop.error(error.localizedDescription)
            }
        }
    }
}
