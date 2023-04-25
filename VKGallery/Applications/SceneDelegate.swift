//
//  SceneDelegate.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let router = AppRouter(window: window, navigationController: UINavigationController())
        let moduleBuilder: ModuleBuilderProtocol = ModuleBuilder(router: router)
        let authViewController = moduleBuilder.buildAuthViewController()
        let mainViewController = moduleBuilder.buildMainViewController()
        let loginVkManager = LoginVKManager()
        if loginVkManager.isAuth() {
            router.setRoot(mainViewController, isNavigationBarHidden: true)
        } else {
            router.setRoot(authViewController, isNavigationBarHidden: true)
        }
        window.makeKeyAndVisible()
        self.window = window
    }
}
