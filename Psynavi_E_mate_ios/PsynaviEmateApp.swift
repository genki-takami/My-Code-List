/*
 アプリのエントリポイント
 */

import SwiftUI

@main
struct PsynaviEmateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
