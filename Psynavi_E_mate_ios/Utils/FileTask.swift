/*
 ユーザーが選択した動画の処理
 */

import AVFoundation

final class FileTask {
    
    static func generateFileURL(with url: URL, handler: @escaping ResultHandler<URL>) {
        
        let video = AVURLAsset(url: url)
        let durationTime = TimeInterval(round(Float(video.duration.value) / Float(video.duration.timescale)))
        let min = Int(durationTime / 60)
        let sec = Int(round(durationTime.truncatingRemainder(dividingBy: 60)))
        
        if min < 1 && sec < 16 {
            /// 拡張子を調整
            let fileType = String(url.absoluteString.lowercased().suffix(3))
            if fileType == "mp4" || fileType == "m4v" {
                /// 一時フォルダを作成
                let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                /// 一時ファイルを作成
                let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent("rendered-video.mp4")
                /// コピーする
                do {
                    try FileManager().copyItem(at: url.absoluteURL, to: temporaryFileURL)
                    handler(.success(temporaryFileURL))
                } catch {
                    handler(.failure(FileTaskError.copyError))
                }
            } else if fileType == "mov" {
                /// エンコードする
                encodeVideo(with: url) { result in
                    switch result {
                    case .success(let temporaryFileURL):
                        if let tmpURL = temporaryFileURL {
                            handler(.success(tmpURL))
                        } else {
                            handler(.failure(FileTaskError.cancelError))
                        }
                    case .failure(let error):
                        handler(.failure(error))
                    }
                }
            } else {
                handler(.failure(FileTaskError.typeError))
            }
        } else {
            handler(.failure(FileTaskError.lengthError))
        }
    }
    
    static func encodeVideo(with videoURL: URL, handler: @escaping ResultHandler<URL?>)  {
        
        let avAsset = AVURLAsset(url: videoURL, options: nil)
                        
        /// エクスポートセッションを作成
        if let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) {
            /// 一時フォルダを作成
            let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            /// 一時ファイルを作成
            let filePath = temporaryDirectoryURL.appendingPathComponent("rendered-video.mp4")
                
            /// 既存のファイルを削除
            if FileManager.default.fileExists(atPath: filePath.path) {
                do {
                    try FileManager.default.removeItem(at: filePath)
                } catch {
                    handler(.failure(FileTaskError.deleteError))
                }
            }
            
            exportSession.outputURL = filePath
            exportSession.outputFileType = AVFileType.mp4
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.timeRange = CMTimeRangeMake(start: CMTimeMakeWithSeconds(0.0, preferredTimescale: 0), duration: avAsset.duration)
                
            exportSession.exportAsynchronously(completionHandler: { () -> Void in
                switch exportSession.status {
                case .failed:
                    handler(.failure(FileTaskError.sessionError))
                case .cancelled:
                    handler(.failure(FileTaskError.cancelError))
                case .completed:
                    handler(.success(exportSession.outputURL))
                default:
                    handler(.failure(FileTaskError.unknown))
                }
            })
        } else {
            handler(.failure(FileTaskError.sessionError))
        }
    }
}
