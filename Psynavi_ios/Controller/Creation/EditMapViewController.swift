/*
 編集オブジェクトのマップの編集処理
 */

import UIKit
import MapKit
import CoreLocation
import SVProgressHUD
import RealmSwift
import Firebase

final class EditMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIViewControllerTransitioningDelegate, DataReturn2 {
    
    // 変数
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    var doubleLat = 35.681236, doubleLon = 139.767125
    let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(35.681236, 139.767125), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var pin: MapAnnotationSetting!
    var uuid, mailAdress, password: String!
    var pinList: [(String,String,String,Double,Double)] = []
    let realm = try! Realm()
    var festivalData: MapDB!
    var downloadLat, downloadLon: Double!
    var downloadableMarkers: Int!
    var locationManager: CLLocationManager!

    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // デリゲート
        mapView.delegate = self
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if let _ = festivalData{
            // 座標が編集済み
            if festivalData.latitude == self.doubleLat && festivalData.longitude == self.doubleLon{
                // リージョンが未保存の場合、初期値は東京駅の位置情報をセット
                mapView.region = self.region
            } else {
                // 保存されている場合はリージョンをセット
                self.doubleLat = festivalData.latitude
                self.latitude.text = "\(self.doubleLat)"
                self.doubleLon = festivalData.longitude
                self.longitude.text = "\(self.doubleLon)"
                mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(self.doubleLat, self.doubleLon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        } else {
            // 新規作成
            mapView.region = self.region// 初期値は東京駅の位置情報をセット
            festivalData = MapDB()
            festivalData.id = NSUUID().uuidString
            festivalData.mailAdress = self.mailAdress
            festivalData.password = self.password
        }
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 保存されたアノテーションがあればマップに表示
        if !festivalData.annotations.isEmpty{
            for i in festivalData.annotations{
                let pin = MapAnnotationSetting()
                pin.coordinate = CLLocationCoordinate2DMake(i.latitude, i.longitude)
                pin.title = i.title
                pin.subtitle = i.subtitle
                pin.pinImage = UIImage(named: i.pinImage)
                let package: (String,String,String,Double,Double) = (i.title,i.subtitle,i.pinImage,i.latitude,i.longitude)
                self.pinList.append(package)
                mapView.addAnnotation(pin)
            }
        }
        
        if let latitude = self.downloadLat, let longitude = self.downloadLon, let count = self.downloadableMarkers {
            // 新規作成
            self.doubleLat = latitude
            self.latitude.text = "\(self.doubleLat)"
            self.doubleLon = longitude
            self.longitude.text = "\(self.doubleLon)"
            mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(self.doubleLat, self.doubleLon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            // FirestoreからPULLする
            if count > 0 {
                SVProgressHUD.show()
                Firestore.firestore().collection(PathName.ListMapID).document(self.uuid).getDocument { (document, error) in
                    if let _ = error{
                        Analytics.logEvent("error_MapEditViewController_viewDidAppear", parameters: [AnalyticsParameterItemName:"マップのドキュメントの取得に失敗" as String])
                        SVProgressHUD.showError(withStatus: "一部のデータが読み込まれませんでした")
                    } else {
                        if document!.exists {
                            if let data = document!.data(){
                                // ピンをマップ上に設置
                                let markers: [String] = data["list"] as! [String]
                                for i in markers{
                                    let thisOne = data[i] as! [String : Any]
                                    let pin = MapAnnotationSetting()
                                    let pinLat = thisOne["latitude"] as! Double
                                    let pinLon = thisOne["longitude"] as! Double
                                    pin.coordinate = CLLocationCoordinate2DMake(pinLat, pinLon)
                                    let pt = thisOne["title"] as! String
                                    pin.title = pt
                                    let ps = thisOne["subtitle"] as! String
                                    pin.subtitle = ps
                                    let image = thisOne["pinImage"] as! String
                                    pin.pinImage = UIImage(named: image)
                                    let package: (String,String,String,Double,Double) = (pt,ps,image,pinLat,pinLon)
                                    self.pinList.append(package)
                                    self.mapView.addAnnotation(pin)
                                }
                            }
                        }
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    // 緯度軽度でリージョンを変更
    @IBAction func changeRegion(_ sender: Any) {
        if let lat = self.latitude.text, let lon = self.longitude.text{
            
            if lat.isEmpty || lon.isEmpty{
                SVProgressHUD.showError(withStatus: "緯度経度を記入してください！")
            } else {
                doubleLat = Double(lat)!
                doubleLon = Double(lon)!
                self.mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(doubleLat, doubleLon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        }
    }
    
    // マップの種類を変更
    @IBAction func chageMapType(_ sender: Any) {
        if self.mapView.mapType == .standard {
            self.mapView.mapType = MKMapType.hybrid// 衛星マップ
        } else if self.mapView.mapType == .hybrid {
            self.mapView.mapType = MKMapType.standard// ２Dマップ
        }
    }
    
    // ピンを追加する
    @IBAction func longPressMap(_ sender: UILongPressGestureRecognizer) {
        // ロングタップの最初の感知のみ受け取る
        if sender.state != UIGestureRecognizer.State.began{
            return
        }
        
        pin = MapAnnotationSetting()
        // ロングタップした位置情報を取得
        let location:CGPoint = sender.location(in: self.mapView)
        // 取得した位置情報をCLLocationCoordinate2D（座標）に変換
        let coordinate:CLLocationCoordinate2D = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        // 座標をピンに設定
        pin.coordinate = coordinate
        
        // 詳細設定に行く
        let pinEditViewController = self.storyboard?.instantiateViewController(withIdentifier: "PinEditView") as! EditMapPinViewController
        pinEditViewController.modalPresentationStyle = .custom
        pinEditViewController.transitioningDelegate = self
        pinEditViewController.delegate = self
        self.present(pinEditViewController, animated: true, completion: nil)
    }
    
    // ポップアップをカスタマイズ
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // 受け取ったデータでピンを表示
    func returnData2(titleData: String, subtitleData: String, imageData: String) {
                
        self.pin.title = titleData
        self.pin.subtitle = subtitleData
        self.pin.pinImage = UIImage(named: imageData)
        let pinLat: Double = self.pin.coordinate.latitude
        let pinLon: Double = self.pin.coordinate.longitude
        let package: (String,String,String,Double,Double) = (titleData,subtitleData,imageData,pinLat,pinLon)
        self.pinList.append(package)
        // ピンを追加
        self.mapView.addAnnotation(self.pin)
        SVProgressHUD.showSuccess(withStatus: "ピンを追加しました！")
    }
    
    // ピンの表示をレイアウト
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
        annotationView.annotation = annotation
        annotationView.canShowCallout = true// ピンをタップした時の吹き出しの表示
        
        // 削除ボタンの設置
        let btn = UIButton()
        btn.frame = CGRect(x:0,y:0,width:40,height:40)
        btn.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        btn.tintColor = UIColor.red
        btn.setTitle("", for: .normal)
        annotationView.rightCalloutAccessoryView = btn

        return annotationView
    }
    
    // マップをタッチした時の処理を返す
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // NONE
    }
    
    // ピンの吹き出しの削除ボタン
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let thisOne = view.annotation
        // 画面表示から削除
        self.mapView.removeAnnotation(thisOne!)
        // ピンのリストから削除
        for (index, i) in pinList.enumerated(){
            if i.0 == thisOne?.title && i.1 == thisOne?.subtitle{
                self.pinList.remove(at: index)
                break
            }
        }
        SVProgressHUD.showSuccess(withStatus: "ピンを削除しました")
    }
    
    // ピンのデータベースへの保存
    @IBAction func savePin(_ sender: Any) {
        SVProgressHUD.show()
        do {
            try realm.write {
                self.festivalData.latitude = self.doubleLat
                self.festivalData.longitude = self.doubleLon
                self.festivalData.annotations.removeAll()
                for i in pinList{
                    let myAnnotation = AnnotationDB()
                    myAnnotation.id = NSUUID().uuidString
                    myAnnotation.title = i.0
                    myAnnotation.subtitle = i.1
                    myAnnotation.pinImage = i.2
                    myAnnotation.latitude = i.3
                    myAnnotation.longitude = i.4
                    self.festivalData.annotations.append(myAnnotation)
                }
                self.realm.add(self.festivalData, update: .modified)
            }
            SVProgressHUD.showSuccess(withStatus: "マップを保存しました")
        } catch _ as NSError {
            Analytics.logEvent("error_MapEditViewController_viewWillDisappear", parameters: [AnalyticsParameterItemName:"マップ(編集)のデータベースへの保存に失敗" as String])
            SVProgressHUD.showError(withStatus: "マップピンの保存に失敗")
        }
    }
}
