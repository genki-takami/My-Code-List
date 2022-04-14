/*
 購入画面のUI
 */

import SwiftUI

struct BillingView: View {
    
    @StateObject var billVM = BillingViewModel()
    @State private var showingDialog = false
    var uid = ""
    
    var body: some View {
        VStack {
            ///
            ///  アプリ内課金に関する注意書き
            ///
            Text(billVM.purchaseAnnotation)
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .font(.custom("HiraMaruProN-W4", size: 14))
                .lineSpacing(6)
            
            Spacer()
            ///
            ///  購入ボタン
            ///
            Button(billVM.purchaseStatusText) {
                if !(billVM.didPurchase(with: uid)) {
                    showingDialog = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundColor(.white)
            .background(billVM.purchaseStatusBackColor)
            .font(.custom("HiraMaruProN-W4", size: 24))
            .confirmationDialog("重要", isPresented: $showingDialog, titleVisibility: .visible) {
                ///
                ///  購入のダイアログ
                ///
                Button("購入する") {
                    if !(uid.isEmpty) {
                        billVM.doPurchase(with: uid)
                    }
                }
                Button("キャンセル", role: .cancel) {
                    showingDialog = false
                }
            } message: {
                Text("購入後は「必ず」確認画面から保存をして下さい")
            }
        }
        .padding(.all, 20)
        .onAppear {
            billVM.setupStatus(with: uid)
        }
    }
}

struct BillingView_Previews: PreviewProvider {
    static var previews: some View {
        BillingView()
    }
}
