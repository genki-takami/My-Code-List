/*
 認証画面のViewModel
 */

import Foundation
import SwiftUI

final class CertificateViewModel: ObservableObject {
    
    @Published var certification: CertificationModel = CertificationModel()
    @Published var statusColor: Color = .red
    @Published var uid = ""
    
    func userActivate() {
        
        Modal.show()
        
        if AuthModule.checkout() {
            /// Active
            statusActivate()
        } else {
            /// No Active
            AuthModule.signInAnonymously() { result in
                switch result {
                case .success(_):
                    /// Active
                    self.statusActivate()
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
    
    private func statusActivate() {
        Modal.showSuccess("準備完了！")
        certification.activate()
        statusColor = .green
    }
    
    func certificate() {
        
        if certification.checkActivate() {
            if uid.isEmpty {
                Modal.showError("IDを入力して下さい")
            } else {
                Modal.show()
                
                FetchData.fetchDocument(uid) { result in
                    switch result {
                    case .success(let data):
                        Modal.dismiss()
                        self.certification.setData(with: data)
                        self.certification.fetchResult(is: true)
                    case .failure(let error):
                        Modal.showError(String(describing: error))
                    }
                }
            }
        } else {
            Modal.showError("ステータスが「編集不可」です。一度アプリを閉じて下さい。")
        }
    }
}
