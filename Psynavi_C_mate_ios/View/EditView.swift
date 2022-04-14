/*
 編集画面のUI
 */

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var editVM = EditViewModel()
    @FocusState var focuses: FocusedFields?
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var showingVideoPicker = false
    @State private var showingBillView = false
    @State private var showingPreview = false
    var data: ShopDisplayModel? = nil
    
    var body: some View {
        VStack {
            ///
            ///  模擬店／展示の名前
            ///
            Text(editVM.editModel.contentTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.all, 10)
                .foregroundColor(.white)
                .background(.blue)
                .font(.custom("HiraMaruProN-W4", size: 26))
            
            ScrollView {
                Group {
                    ///
                    ///  運営団体名
                    ///
                    VStack {
                        Text("運営団体")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                            .font(.custom("HiraMaruProN-W4", size: 24))
                        
                        TextField("運営する団体名",text: $editVM.manager)
                            .font(.custom("HiraMaruProN-W4", size: 14))
                            .frame(height: 30)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1).padding(.horizontal, -8))
                            .padding(.horizontal, 8)
                            .focused($focuses, equals: .manager)
                    }
                    ///
                    ///  日時
                    ///
                    VStack {
                        Text("日時")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                            .foregroundColor(.black)
                            .font(.custom("HiraMaruProN-W4", size: 24))
                        
                        TextField("運営する日時",text: $editVM.date)
                            .font(.custom("HiraMaruProN-W4", size: 14))
                            .frame(height: 30)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1).padding(.horizontal, -8))
                            .padding(.horizontal, 8)
                            .focused($focuses, equals: .date)
                    }
                    ///
                    ///  場所
                    ///
                    VStack {
                        Text("場所")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                            .foregroundColor(.black)
                            .font(.custom("HiraMaruProN-W4", size: 24))
                        
                        TextField("運営する場所",text: $editVM.place)
                            .font(.custom("HiraMaruProN-W4", size: 14))
                            .frame(height: 30)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1).padding(.horizontal, -8))
                            .padding(.horizontal, 8)
                            .focused($focuses, equals: .place)
                    }
                    ///
                    ///  画像
                    ///
                    VStack(alignment: .center) {
                        Button("画像を選択") {
                            showingImagePicker = true
                        }
                        .frame(height: 43)
                        .padding(.horizontal, 10)
                        .font(.custom("HiraMaruProN-W4", size: 24))
                        .foregroundColor(.white)
                        .background(.blue)
                        
                        if editVM.isNewImage {
                            if let uiImage = image {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 175)
                            } else {
                                Image("Loading")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 175)
                            }
                        } else {
                            AsyncImage(url: data!.url) { downloadImage in
                                downloadImage.resizable()
                                     .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Image("Loading")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .frame(height: 175)
                        }
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(selectedImage: $image, isNewImage: $editVM.isNewImage, videoURL: $editVM.videoURL, isVideo: false, sourceType: .photoLibrary)
                    }
                    ///
                    ///  タグ
                    ///
                    VStack {
                        Text("タグ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                            .foregroundColor(.black)
                            .font(.custom("HiraMaruProN-W4", size: 24))
                        
                        TextField("タグをつけよう！",text: $editVM.tag)
                            .font(.custom("HiraMaruProN-W4", size: 14))
                            .frame(height: 30)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1).padding(.horizontal, -8))
                            .padding(.horizontal, 8)
                            .focused($focuses, equals: .tag)
                    }
                    ///
                    ///  説明
                    ///
                    VStack {
                        Text("説明")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                            .foregroundColor(.black)
                            .font(.custom("HiraMaruProN-W4", size: 24))
                        
                        TextEditor(text: $editVM.info)
                            .frame(height: 115)
                            .font(.custom("HiraMaruProN-W4", size: 14))
                            .foregroundColor(.black)
                            .background(Color("CustomGray"))
                            .focused($focuses, equals: .info)
                    }
                    ///
                    ///  団体情報
                    ///
                    VStack {
                        Text("団体情報")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                            .foregroundColor(.black)
                            .font(.custom("HiraMaruProN-W4", size: 24))
                        
                        TextEditor(text: $editVM.managerInfo)
                            .frame(height: 115)
                            .font(.custom("HiraMaruProN-W4", size: 14))
                            .foregroundColor(.black)
                            .background(Color("CustomGray"))
                            .focused($focuses, equals: .managerInfo)
                    }
                    
                    VStack(alignment: .center, spacing: 15) {
                        ///
                        ///  動画
                        ///
                        Button(editVM.editModel.videoLabel) {
                            if editVM.checkPurchaseStatus() {
                                showingVideoPicker = true
                            } else {
                                showingBillView = true
                            }
                        }
                        .frame(height: 43)
                        .padding(.horizontal, 10)
                        .font(.custom("HiraMaruProN-W4", size: 24))
                        .foregroundColor(.white)
                        .background(.purple)
                        .sheet(isPresented: $showingVideoPicker) {
                            ImagePicker(selectedImage: $image, isNewImage: $editVM.isNewImage, videoURL: $editVM.videoURL, isVideo: true, sourceType: .photoLibrary)
                        }
                        .sheet(isPresented: $showingBillView) {
                            BillingView(uid: editVM.key)
                        }
                        ///
                        ///  確認画面と保存
                        ///
                        Button("確認画面へ") {
                            showingPreview = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .font(.custom("HiraMaruProN-W4", size: 24))
                        .foregroundColor(.white)
                        .background(.black)
                        .sheet(isPresented: $showingPreview) {
                            PreviewAndSave(basicData: ShopDisplayModel(documentID: data!.documentID, uid: data!.uid, name: editVM.editModel.contentTitle, date: editVM.date, place: editVM.place, manager: editVM.manager, managerInfo: editVM.managerInfo, tag: editVM.tag, info: editVM.info, upgrade: editVM.upgrade, video: data!.video, url: data!.url), isNewImage: editVM.isNewImage, newImage: image, downloadImageURL: editVM.editModel.contentImageURL, videoURL: editVM.videoURL)
                        }
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
                    }
                    .padding(.top, 8)
                }
                .frame(maxHeight: .infinity)
                .padding(.bottom, 400)
            }
            .padding(.top, 20)
            .padding(.horizontal, 15)
        }
        .padding(.top, 1)
        .ignoresSafeArea(edges: .vertical)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            editVM.setupView(with: data)
        }
        .onDisappear {
            UITextView.appearance().backgroundColor = nil
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            EditView()
        }
    }
}
