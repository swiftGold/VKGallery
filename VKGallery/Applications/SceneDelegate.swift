//
//  SceneDelegate.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import UIKit
import VK_ios_sdk

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AuthServiceDelegate {

    var window: UIWindow?
    var authService: AuthService!

    static func shared() -> SceneDelegate {
        let scene = UIApplication.shared.connectedScenes.first
        let sd: SceneDelegate = ((scene?.delegate as? SceneDelegate)!)
        return sd
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let router = AppRouter(window: window, navigationController: UINavigationController())
        self.authService = AuthService()
        authService.delegate = self
        let moduleBuilder: ModuleBuilderProtocol = ModuleBuilder(router: router)
        let authViewController = moduleBuilder.buildAuthViewController()
        router.setRoot(authViewController, isNavigationBarHidden: true)
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
    
    func authServiceShouldShow(_ viewController: UIViewController) {
        print(#function)
        window?.rootViewController?.present(viewController, animated: true)
    }
    
    func authServiceSignIn() {
        print(#function)
        let router = AppRouter(window: window!, navigationController: UINavigationController())
        let moduleBuilder: ModuleBuilderProtocol = ModuleBuilder(router: router)
        let mainViewController = moduleBuilder.buildMainViewController()
        router.setRoot(mainViewController, isNavigationBarHidden: true)
    }
    
    func authServiceSignInDidFail() {
        print(#function)
    }
}


