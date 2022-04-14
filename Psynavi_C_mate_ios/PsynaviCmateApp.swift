/*
 アプリのエントリポイント
 */

import SwiftUI

@main
struct PsynaviCmateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
