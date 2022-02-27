/*
 EditMapViewControllerの拡張
 */

extension EditMapViewController: SaveMarker {
    
    /// マップのピン(マーカー)を保存
    func saveMarker() {
        
        Modal.show()
        
        let data: [String:Any] = [
            "latitude": doubleLat,
            "longitude": doubleLon,
            "pinList": pinList,
        ]
        
        RealmTask.add(festivalData, data, EditMode.modify, RealmModel.map) { result in
            switch result {
            case .success(_):
                Modal.showSuccess("マップを保存しました")
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
        }
    }
}
