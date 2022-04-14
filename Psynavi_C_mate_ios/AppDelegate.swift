/*
 AppDelegate.swift
 */

import UIKit
import Firebase
import StoreKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    /// For SVProgressHUD
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Firebaseをセットアップ
        FirebaseApp.configure()
        /// App内課金をセットアップ
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            SKPaymentQueue.default().add(StoreManager.shared)
        }
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        /// Sceneの呼び出し
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        /// アプリ終了
    }
    
    /// アプリが終了する時
    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(StoreManager.shared)
    }
}

