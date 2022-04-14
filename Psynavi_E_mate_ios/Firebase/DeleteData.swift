/*
 Firebase関係の処理
 */

import FirebaseStorage

final class DeleteData {
    
    static func deleteImage(path reference: StorageReference, handler: @escaping ResultHandler<String>) {
        reference.delete { error in
            if let _ = error {
                handler(.failure(FirebaseError.imageDeleteError))
            } else {
                handler(.success("アップロード完了！"))
            }
        }
    }
}
