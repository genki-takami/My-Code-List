//
//  ImageShowView.swift
//  Psynavi E-mate
//
//  Created by 髙見元基 on 2022/04/10.
//

import SwiftUI

struct ImageShowView: View {
    
    var imageBox: EventImage
    var caption: String
    
    var body: some View {
        VStack {
            if imageBox.isNewImage {
                ///
                /// 新規の画像
                ///
                if let uiImage = imageBox.uploadImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("Loading")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            } else {
                ///
                /// Firebaseにある画像
                ///
                AsyncImage(url: imageBox.downloadImage!.url) { downloadImage in
                    downloadImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image("Loading")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            
            ScrollView(showsIndicators: false) {
                Text(String(caption.dropFirst(10)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("HiraMaruProN-W4", size: 17))
                    .foregroundColor(.white)
                    .lineSpacing(5)
                
                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal, 20)
        }
        .background(Color("CustomBlack"))
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct ImageShowView_Previews: PreviewProvider {
    static var previews: some View {
        ImageShowView(
            imageBox: EventImage(isNewImage: true, downloadImage: nil, uploadImage: nil),
            caption: "これはキャプション\nこれはキャプション\nこれはキャプション\nこれはキャプション\nこれはキャプション\nこれはキャプション"
        )
    }
}
