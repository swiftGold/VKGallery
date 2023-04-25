//
//  WebViewPresenter.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 24.04.2023.
//

import UIKit

protocol WebViewPresenterProtocol {
    func viewDidLoad()
    func didTapCloseButton()
    func didFetchToken()
}

// MARK: - WebViewPresenter
final class WebViewPresenter {
    weak var viewController: WebViewViewControllerProtocol?
    
    private let router: Router
    private let moduleBuilder: ModuleBuilderProtocol
    private let loginVKManager: LoginVKManagerProtocol
    private let alertManager: AlertManagerProtocol
    
    init(
        router: Router,
        moduleBuilder: ModuleBuilderProtocol,
        loginVKManager: LoginVKManagerProtocol,
        alertManager: AlertManagerProtocol
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
        self.loginVKManager = loginVKManager
        self.alertManager = alertManager
    }
}

// MARK: - WebViewPresenterProtocol impl
extension WebViewPresenter: WebViewPresenterProtocol {
    func viewDidLoad() {}
    
    func didTapCloseButton() {
        let alert = UIAlertController(
            title: "alert.close.title".localized,
            message: "alert.close.message".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "alert.ok.title".localized, style: .default) { _ in
            let authViewController = self.moduleBuilder.buildAuthViewController()
            self.router.push(authViewController, animated: true)
        })
        alert.addAction(UIAlertAction(title: "alert.cancel.title".localized, style: .destructive) { _ in
            print("cancel")
        })
        viewController?.present(alert, animated: true)
    }
    
    func didFetchToken() {
        let mainViewController = moduleBuilder.buildMainViewController()
        router.push(mainViewController, animated: true)
    }
}
