//
//  CaptionEditView.swift
//  Psynavi E-mate
//
//  Created by 髙見元基 on 2022/04/10.
//

import SwiftUI

struct CaptionEditView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedImage: UIImage?
    @Binding var editModel: EditModel
    @FocusState var focuses: FocusedFields?
    @State private var captionText = "100文字以内"
    
    var body: some View {
        VStack {
            HStack {
                ///
                ///  戻るボタン
                ///
                Button("キャンセル") {
                    dismiss()
                }
                .font(.custom("HiraMaruProN-W4", size: 18))
                .foregroundColor(.blue)
                
                Spacer()
                ///
                ///  保存ボタン
                ///
                Button("保存") {
                    if captionText.isEmpty {
                        Modal.showError("キャプション(注釈)\nを入力してください")
                    } else {
                        if let uiImage = selectedImage {
                            editModel.addImage(uiImage)
                            editModel.addCaption(captionText)
                            selectedImage = nil
                            dismiss()
                        } else {
                            Modal.showError("画像を再度選択してください")
                        }
                    }
                }
                .font(.custom("HiraMaruProN-W4", size: 18))
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            ///
            ///  キャプション入力
            ///
            VStack {
                Text("キャプション")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 15)
                    .foregroundColor(.black)
                    .font(.custom("HiraMaruProN-W4", size: 24))
                
                TextEditor(text: $captionText)
                    .frame(height: 150)
                    .font(.custom("HiraMaruProN-W4", size: 14))
                    .foregroundColor(.black)
                    .background(Color("CustomGray"))
                    .focused($focuses, equals: .imageCaption)
            }
            .padding(.horizontal, 15)
            ///
            ///  選択された画像
            ///
            if let uiImage = selectedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            } else {
                Text("画像が読み込まれませんでした")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.red)
                    .font(.custom("HiraMaruProN-W4", size: 17))
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(30)
                    .foregroundColor(.yellow)
            }
            
            Spacer()
        }
        .padding(.top, 1)
        .ignoresSafeArea(edges: .vertical)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .onDisappear {
            UITextView.appearance().backgroundColor = nil
        }
    }
}

struct CaptionEditView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CaptionEditView(selectedImage: Binding.constant(nil), editModel: Binding.constant(EditModel()))
        }
    }
}
