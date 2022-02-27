/*
 編集オブジェクトのマップの編集処理
 */

import MapKit

final class EditMapViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    var doubleLat = 35.681236, doubleLon = 139.767125
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
        setupView()
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
    
    // MARK: - SAVE
    @IBAction private func savePin(_ sender: Any) {
        saveMarker()
    }
}
