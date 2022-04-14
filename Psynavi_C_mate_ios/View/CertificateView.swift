/*
 認証画面のUI
 */

import SwiftUI

struct CertificateView: View {
    
    @StateObject private var cerVM = CertificateViewModel()
    @FocusState var focuses: FocusedFields?
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                ///
                ///  編集できるかのステータス(匿名ログインに成功したかの状態)
                ///
                Text(cerVM.certification.statusText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(cerVM.statusColor)
                    .font(.custom("HiraMaruProN-W4", size: 17))
                
                Text("模擬店 / 展示 ID")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                    .font(.custom("HiraMaruProN-W4", size: 17))
                    .padding(.top, 50)
                ///
                ///  ID入力エリア
                ///
                TextField("ex：550e8400-e29b-41d4-a716-446655440000", text: $cerVM.uid)
                    .font(.custom("HiraMaruProN-W4", size: 14))
                    .frame(height: 30)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1).padding(.horizontal, -8))
                    .padding(.horizontal, 8)
                    .focused($focuses, equals: .uid)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button("キーボードを閉じる") {
                                    focuses = nil
                                }
                            }
                        }
                    }
                ///
                ///  認証ボタン
                ///
                Button(action: {
                    cerVM.certificate()
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .font(.title)
                }
                .frame(width: 80, height: 40)
                .background(.blue)
                .padding(.vertical, 30)
                .sheet(isPresented: $cerVM.certification.isFetched) {
                    EditView(focuses: _focuses, data: cerVM.certification.data)
                }
                ///
                ///  ID取得時の注意書き
                ///
                Text(cerVM.certification.annotationText)
                    .frame(maxWidth: .infinity, minHeight: 209, alignment: .leading)
                    .padding(.all, 7)
                    .foregroundColor(.black)
                    .background(Color("CustomYellow"))
                    .font(.custom("HiraMaruProN-W4", size: 17))
                    .lineSpacing(7)
                ///
                ///  雰囲気の画像
                ///
                HStack {
                    Spacer()
                    Image("home")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                }
                
                Spacer()
            }
            .padding(.all, 20)
            .onAppear {
                cerVM.userActivate()
            }
        }
    }
}

struct CertificateView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CertificateView()
        }
    }
}
