//
//  AuthPresenter.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import UIKit

protocol AuthPresenterProtocol {
    func viewDidLoad()
    func didTapVkButton()
}

// MARK: - AuthPresenter 
final class AuthPresenter {
    weak var viewController: AuthViewControllerProtocol?
    
    private let router: Router
    private let moduleBuilder: ModuleBuilderProtocol
    private let loginVKManager: LoginVKManagerProtocol
    
    init(
        router: Router,
        moduleBuilder: ModuleBuilderProtocol,
        loginVKManager: LoginVKManagerProtocol
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
        self.loginVKManager = loginVKManager
    }
}

// MARK: - AuthPresenterProtocol impl
extension AuthPresenter: AuthPresenterProtocol {
    func viewDidLoad() {}
    
    func didTapVkButton() {
        if loginVKManager.isAuth() {
            let mainViewController = moduleBuilder.buildMainViewController()
            router.push(mainViewController, animated: true)
        } else {
            let webViewController = moduleBuilder.buildWebViewViewController()
            router.push(webViewController, animated: true)
        }
    }
}
