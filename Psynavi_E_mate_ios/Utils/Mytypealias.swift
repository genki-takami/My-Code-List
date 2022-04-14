/*
 作成したタイプエイリアス
 */

import Foundation
import FirebaseStorage

typealias ResultHandler<T> = (Result<T, Error>) -> Void

typealias DownloadImageBox = (url: URL, reference: StorageReference)
