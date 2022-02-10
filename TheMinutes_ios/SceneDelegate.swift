/*
 SceneDelegate.swift
 */

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Scene召喚
        guard let _ = (scene as? UIWindowScene) else { return }
        
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       appDelegate.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene終了
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Scene活性化
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Scene非活性化
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Scene前画面モード
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Sceneバックグラウンドモード
    }
}

