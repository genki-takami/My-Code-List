/*
 ユーザーが選択した画像の処理
 */

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var selectedImage: UIImage?
    @Binding var isNewImage: Bool
    @Binding var videoURL: URL?
    var isVideo: Bool
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        if isVideo {
            imagePicker.title = "video"
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.allowsEditing = true
            imagePicker.videoQuality = .typeLow
        } else {
            imagePicker.title = "image"
            imagePicker.allowsEditing = false
        }
        
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if picker.title == "image" {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImage = image
                    parent.isNewImage = true
                }
                parent.presentationMode.wrappedValue.dismiss()
            } else if picker.title == "video" {
                guard let info = info[.mediaURL] as? NSURL else { fatalError() }
                Modal.show()
                FileTask.generateFileURL(with: info as URL) { result in
                    switch result {
                    case .success(let url):
                        self.parent.videoURL = url
                        self.parent.presentationMode.wrappedValue.dismiss()
                        Modal.showSuccess("動画を設定しました")
                    case .failure(let error):
                        self.parent.presentationMode.wrappedValue.dismiss()
                        Modal.showError(String(describing: error))
                    }
                }
            }
        }
    }
}
