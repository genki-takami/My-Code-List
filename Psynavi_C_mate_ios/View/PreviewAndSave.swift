/*
 プレビュー画面のUI
 */

import SwiftUI
import AVKit

struct PreviewAndSave: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var previewVM = PreviewAndSaveViewModel()
    var basicData: ShopDisplayModel? = nil
    var isNewImage = false
    var newImage: UIImage? = nil
    var downloadImageURL: URL? = nil
    var videoURL: URL? = nil
    
    var body: some View {
        VStack {
            ZStack {
                ///
                ///  模擬店／展示の画像
                ///
                if isNewImage {
                    if let uiImage = newImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    }
                } else {
                    AsyncImage(url: downloadImageURL!) { downloadImage in
                        downloadImage.resizable()
                             .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Image("Loading")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(maxWidth: .infinity)
                }
                ///
                ///  模擬店／展示の動画
                ///
                if previewVM.isReadyForPlayVideo {
                    let player = AVPlayer(url: previewVM.videoURL!)
                    PlayerViewController(player: player)
                        .onAppear {
                            player.play()
                            if previewVM.onStreaming {
                                Modal.showMessage("ストリーミング中")
                                previewVM.onStreaming = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    Modal.dismiss()
                                }
                            }
                        }
                        .onDisappear {
                            previewVM.isReadyForPlayVideo = false
                        }
                }
            }
            
            ZStack {
                ///
                ///  模擬店／展示の名前
                ///
                Rectangle()
                    .foregroundColor(Color("CustomBlue"))
                    .frame(maxWidth: .infinity, maxHeight: 50)
                
                Text(previewVM.contentName)
                    .font(.custom("HiraMaruProN-W4", size: 24))
                    .foregroundColor(.white)
                    .underline()
                    .lineLimit(1)
            }
            .padding(.vertical, -8)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    ZStack(alignment: .top) {
                        Image("blueWallPaper")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(x: 1, y: 1.18, anchor: .top)
                        
                        VStack {
                            ///
                            ///  模擬店／展示の動画の再生終了ボタン
                            ///
                            Label(previewVM.isReadyForPlayVideo ? "動画を終了" : "動画を再生", systemImage: "play.rectangle.fill")
                                .padding(.top, 55)
                                .foregroundColor(.purple)
                                .onTapGesture {
                                    if previewVM.isReadyForPlayVideo {
                                        previewVM.isReadyForPlayVideo = false
                                    } else {
                                        previewVM.playVideo(from: videoURL)
                                    }
                                }
                            ///
                            ///  模擬店／展示のタグ
                            ///
                            Label(previewVM.tag, systemImage: "tag.fill")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 10)
                                .foregroundColor(.orange)
                                .lineLimit(1)
                            
                            Group {
                                Group {
                                    ///
                                    ///  模擬店／展示の運営
                                    ///
                                    VStack(alignment: .center, spacing: 10) {
                                        Text("ー 運営 ー")
                                        Text(previewVM.manager)
                                    }
                                    ///
                                    ///  模擬店／展示の日時
                                    ///
                                    VStack(alignment: .center, spacing: 10) {
                                        Text("ー 日時 ー")
                                        Text(previewVM.date)
                                    }
                                    ///
                                    ///  模擬店／展示の運営場所
                                    ///
                                    VStack(alignment: .center, spacing: 10) {
                                        Text("ー 運営場所 ー")
                                        Text(previewVM.place)
                                    }
                                }
                                .lineLimit(1)
                                ///
                                ///  模擬店／展示の詳細
                                ///
                                VStack(alignment: .center, spacing: 10) {
                                    Text("ー 詳細 ー")
                                    Text(previewVM.info)
                                        .frame(height: 90, alignment: .leading)
                                }
                                ///
                                ///  模擬店／展示の団体情報
                                ///
                                VStack(alignment: .center, spacing: 10) {
                                    Text("ー 団体情報 ー")
                                    Text(previewVM.managerInfo)
                                        .frame(height: 90, alignment: .leading)
                                }
                            }
                            .foregroundColor(.black)
                            .padding(.bottom, 10)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .font(.custom("HiraMaruProN-W4", size: 17))
                    }
                    
                    HStack(alignment: .center, spacing: 30) {
                        ///
                        ///  前の画面に戻る
                        ///
                        Button(action: {
                            dismiss()
                        })
                        {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                        .frame(width: 80, height: 40)
                        .background(.blue)
                        .border(.white, width: 2)
                        ///
                        ///  保存
                        ///
                        Button(previewVM.saveLabel) {
                            previewVM.save(url: videoURL, imageBool: isNewImage, newImage: newImage)
                        }
                        .frame(height: 43)
                        .padding(.horizontal, 10)
                        .font(.custom("HiraMaruProN-W4", size: 24))
                        .foregroundColor(previewVM.saveLabel == "保存する" ? .white : .gray)
                        .background(previewVM.saveLabel == "保存する" ? .orange : .black)
                        .border(.white, width: 2)
                        
                        Spacer()
                    }
                    .padding(.all, 20)
                }
                .background(Color("CustomBlue"))
            }
        }
        .ignoresSafeArea(edges: .vertical)
        .onAppear {
            UIScrollView.appearance().bounces = false
            previewVM.setupView(with: basicData)
        }
    }
}

struct PreviewAndSave_Previews: PreviewProvider {
    static var previews: some View {
        PreviewAndSave()
    }
}
