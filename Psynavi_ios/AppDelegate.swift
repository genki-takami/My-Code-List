/*
 AppDelegate.swift
 */

import UIKit
import Firebase
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // アプリ起動
        
        // Set-Up Firebase
        FirebaseApp.configure()
        // Set-Up In-App Purchase AFTER 2 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            SKPaymentQueue.default().add(StoreManager.shared)
        }
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Sceneの呼び出し
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // アプリ終了
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Finish SKPaymentQueue
        SKPaymentQueue.default().remove(StoreManager.shared)
        // Signout Account
        guard let _ = Auth.auth().currentUser else { return }
        try! Auth.auth().signOut()
    }
}

