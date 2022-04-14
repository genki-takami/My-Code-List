//
//  EditView.swift
//  Psynavi E-mate
//
//  Created by 髙見元基 on 2022/04/08.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var editVM = EditViewModel()
    @FocusState var focuses: FocusedFields?
    @State private var image: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var showingCaptionEditor = false
    @State private var showingImageData = false
    @State private var showingDialog = false
    @State private var showingVideoPicker = false
    @State private var showingBillView = false
    @State private var showingPreview = false
    private let threeColumnGrid = [
        GridItem(.flexible(minimum: 40), spacing: 0),
        GridItem(.flexible(minimum: 40), spacing: 0),
        GridItem(.flexible(minimum: 40)),
    ]
    var data: EventModel? = nil
    
    var body: some View {
        VStack {
            ///
            ///  企画イベントの名前
            ///
            Text(editVM.editModel.eventTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.all, 10)
                .foregroundColor(.white)
                .background(.yellow)
                .font(.custom("HiraMaruProN-W4", size: 26))
            
            ScrollView {
                Group {
                    ///
                    /// 内容
                    ///
                    VStack {
                        Text("内容")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                            .font(.custom("HiraMaruProN-W4", size: 24))
                        
                        TextEditor(text: $editVM.caption)
                            .frame(height: 250)
                            .font(.custom("HiraMaruProN-W4", size: 14))
                            .foregroundColor(.black)
                            .background(Color("CustomGray"))
                            .focused($focuses, equals: .caption)
                    }
                    ///
                    /// 日時
                    ///
                    VStack {
                        Text("日時")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                            .foregroundColor(.black)
                            .font(.custom("HiraMaruProN-W4", size: 24))
                        
                        TextField("企画する日時",text: $editVM.date)
                            .font(.custom("HiraMaruProN-W4", size: 14))
                            .frame(height: 30)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1).padding(.horizontal, -8))
                            .padding(.horizontal, 8)
                            .focused($focuses, equals: .date)
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
                            ImagePicker(selectedImage: $image, showCaptionEditor: $showingCaptionEditor, videoURL: $editVM.videoURL, isVideo: true, sourceType: .photoLibrary)
                        }
                        .sheet(isPresented: $showingBillView) {
                            BillingView(uid: editVM.key)
                        }
                        
                        HStack {
                            ///
                            ///  前の画面に戻る
                            ///
                            Button(action: {
                                dismiss()
                            })
                            {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 20)
                                    .font(.custom("HiraMaruProN-W4", size: 24))
                            }
                            .frame(width: 40)
                            .background(.blue)
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
                                PreviewAndSave(
                                    basicData: EventModel(documentID: data!.documentID,
                                                          uid: data!.uid,
                                                          eventTitle: editVM.editModel.eventTitle,
                                                          eventDate: editVM.date,
                                                          caption: editVM.caption,
                                                          imageCaptions: editVM.editModel.eventImageCaptions,
                                                          upgrade: editVM.upgrade,
                                                          video: data!.video,
                                                          imageBox: editVM.editModel.eventImageBox),
                                    videoURL: editVM.videoURL,
                                    deleteList: editVM.deleteList
                                )
                            }
                        }
                    }
                    .padding(.top, 8)
                    ///
                    /// 画像とキャプション
                    ///
                    VStack(alignment: .center) {
                        Text("画像とキャプション")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 8)
                            .foregroundColor(.black)
                            .font(.custom("HiraMaruProN-W4", size: 24))
                        ///
                        /// 画像選択
                        ///
                        Button("画像を選択") {
                            showingImagePicker = true
                        }
                        .frame(height: 43)
                        .padding(.horizontal, 10)
                        .font(.custom("HiraMaruProN-W4", size: 24))
                        .foregroundColor(.white)
                        .background(.blue)
                        ///
                        /// ロングタップ処理の注釈
                        ///
                        Label("長押しで削除可能", systemImage: "info.circle")
                            .foregroundColor(.blue)
                        ///
                        /// 画像のグリッドレイアウト
                        ///
                        LazyVGrid(columns: threeColumnGrid, alignment: .leading, spacing: 0) {
                            ForEach(editVM.editModel.eventImageBox) { imageBox in
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
                                    editVM.currentBox = imageBox
                                    showingImageData = true
                                }
                                .onLongPressGesture {
                                    editVM.currentBox = imageBox
                                    showingDialog = true
                                }
                            }
                        }
                        .frame(minHeight: 40)
                        .background(.gray)
                        
                    }.sheet(isPresented: $showingImagePicker) {
                        ImagePicker(selectedImage: $image, showCaptionEditor: $showingCaptionEditor, videoURL: $editVM.videoURL, isVideo: false, sourceType: .photoLibrary)
                    }
                    .sheet(isPresented: $showingCaptionEditor) {
                        CaptionEditView(selectedImage: $image, editModel: $editVM.editModel, focuses: _focuses)
                    }
                    .sheet(isPresented: $showingImageData) {
                        let captionText = editVM.editModel.getCaption(editVM.currentBox!)
                        ImageShowView(imageBox: editVM.currentBox!, caption: captionText)
                    }
                    .confirmationDialog("確認", isPresented: $showingDialog, titleVisibility: .visible) {
                        ///
                        ///  画像とキャプションの削除ダイアログ
                        ///
                        Button("削除する", role: .destructive) {
                            if !(editVM.currentBox!.isNewImage) {
                                editVM.addWillDelete(at: editVM.currentBox!.downloadImage!.reference)
                            }
                            editVM.editModel.removeImage(editVM.currentBox!)
                        }
                        Button("キャンセル", role: .cancel) {
                            showingDialog = false
                        }
                    } message: {
                        Text("選択した画像を削除しますか？")
                    }
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
