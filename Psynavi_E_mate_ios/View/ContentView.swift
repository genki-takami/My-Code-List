/*
 ルートビュー
 */

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        CertificateView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ContentView()
        }
    }
}
