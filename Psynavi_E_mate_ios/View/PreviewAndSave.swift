//
//  PreviewAndSave.swift
//  Psynavi E-mate
//
//  Created by 髙見元基 on 2022/04/10.
//

import SwiftUI
import AVKit
import FirebaseStorage

struct PreviewAndSave: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var previewVM = PreviewAndSaveViewModel()
    @State private var showingImageData = false
    var basicData: EventModel? = nil
    var videoURL: URL? = nil
    var deleteList = [StorageReference]()
    private let threeColumnGrid = [
        GridItem(.flexible(minimum: 40), spacing: 0),
        GridItem(.flexible(minimum: 40), spacing: 0),
        GridItem(.flexible(minimum: 40)),
    ]
    
    var body: some View {
        VStack {
            HStack {
                ///
                ///  前の画面に戻る
                ///
                Button(action: {
                    dismiss()
                })
                {
                    Image(systemName: "chevron.down")
                        .font(.custom("GillSans-UltraBold", size: 24))
                        .foregroundColor(.blue)
                        .padding(.vertical, 15)
                }
                .frame(width: 40)
                
                Spacer()
                ///
                ///  保存ボタン
                ///
                Button(previewVM.saveLabel) {
                    previewVM.save(url: videoURL)
                }
                .font(.custom("HiraMaruProN-W4", size: 24))
                .padding(.all, 15)
                .foregroundColor(previewVM.saveLabel == "保存する" ? .white : .gray)
                .background(previewVM.saveLabel == "保存する" ? .orange : .black)
            }
            .background(.white)
            
            Group {
                ZStack {
                    ///
                    ///  画像のグリッドレイアウトビュー
                    ///
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: threeColumnGrid, alignment: .leading, spacing: 0) {
                            ForEach(previewVM.imageBox) { imageBox in
                                Group {
                                    if imageBox.isNewImage {
                                        ///
                                        /// 新規の画像
                                        ///
                                        if let uiImage = imageBox.uploadImage {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .aspectRatio(1, contentMode: .fill)
                                        } else {
                                            Image("Loading")
                                                .resizable()
                                                .aspectRatio(1, contentMode: .fill)
                                        }
                                    } else {
                                        ///
                                        /// Firebaseにある画像
                                        ///
                                        AsyncImage(url: imageBox.downloadImage!.url) { downloadImage in
                                            downloadImage
                                                .resizable()
                                                .aspectRatio(1, contentMode: .fill)
                                        } placeholder: {
                                            Image("Loading")
                                                .resizable()
                                                .aspectRatio(1, contentMode: .fill)
                                        }
                                    }
                                }
                                .onTapGesture {
                                    previewVM.currentBox = imageBox
                                    showingImageData = true
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showingImageData) {
                        let captionText = previewVM.getCaption(previewVM.currentBox!)
                        ImageShowView(imageBox: previewVM.currentBox!, caption: captionText)
                    }
                    ///
                    /// 企画イベントの動画
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
                
                HStack {
                    ///
                    ///  企画イベントの名前
                    ///
                    Text(previewVM.eventName)
                        .frame(maxWidth: .infinity)
                        .font(.custom("HiraMaruProN-W4", size: 24))
                        .lineLimit(1)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(Color("CustomGreen"))
                    ///
                    ///  動画の再生ボタン
                    ///
                    Button(action: {
                        if previewVM.isReadyForPlayVideo {
                            previewVM.isReadyForPlayVideo = false
                        } else {
                            previewVM.playVideo(from: videoURL)
                        }
                    })
                    {
                        if previewVM.isReadyForPlayVideo {
                            Image(systemName: "pause.circle")
                                .font(.custom("HiraMaruProN-W4", size: 24))
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "play.circle")
                                .font(.custom("HiraMaruProN-W4", size: 24))
                                .foregroundColor(.purple)
                        }
                    }
                    .frame(width: 40)
                    .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 5)
                ///
                ///  企画イベントの日時
                ///
                HStack {
                    Spacer(minLength: 40)
                    
                    Text(previewVM.date)
                        .frame(maxWidth: .infinity)
                        .font(.custom("HiraMaruProN-W4", size: 20))
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .background(Color("CustomWakakusa"))
                }
                .frame(maxWidth: .infinity)
                ///
                ///  企画イベントの説明・内容
                ///
                ScrollView(showsIndicators: false) {
                    Text(previewVM.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("HiraMaruProN-W4", size: 17))
                        .lineSpacing(5)
                        .padding(.all, 10)
                        .padding(.bottom, 20)
                }
                .frame(height: 222)
            }
            .padding(.top, -8)
        }
        .ignoresSafeArea(edges: .vertical)
        .background(.yellow)
        .onAppear {
            UIScrollView.appearance().bounces = false
            previewVM.setupView(with: basicData, prepare: deleteList)
        }
    }
}

struct PreviewAndSave_Previews: PreviewProvider {
    static var previews: some View {
        PreviewAndSave()
    }
}
