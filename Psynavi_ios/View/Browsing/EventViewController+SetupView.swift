/*
 EventViewControllerの拡張
 */

extension EventViewController {
    
    /// UIのセットアップ
    func setupView() {
        /// テキストデータ
        eventTitleLabel.text = eventTitle
        eventDateLabel.text = eventDate
        eventCaptionTextView.text = caption
        /// Storageにある画像データのパスをrefArrayに加える
        if imageCaptions.count > 0 {
            for cap in imageCaptions {
                let ref = FetchData.getPath4StorageReference(uuid, PathName.EventImagePath, eventTitle, cap.prefix(10) + ".jpg")
                refArray.append(ref)
            }
        }
    }
}
