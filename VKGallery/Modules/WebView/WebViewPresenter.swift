//
//  WebViewPresenter.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 24.04.2023.
//

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

// MARK: - WebViewPresenterProtocol impl
extension WebViewPresenter: WebViewPresenterProtocol {
    func viewDidLoad() {
        
    }
    
    func didTapCloseButton() {
        let authViewController = moduleBuilder.buildAuthViewController()
        router.push(authViewController, animated: true)
    }
    
    func didFetchToken() {
        let mainViewController = moduleBuilder.buildMainViewController()
        router.push(mainViewController, animated: true)
    }
}
