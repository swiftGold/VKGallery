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

final class AuthPresenter {
    weak var viewController: AuthViewControllerProtocol?
    
    private let router: Router
    private let moduleBuilder: ModuleBuilderProtocol
    private var authService = SceneDelegate.shared().authService
    
    init(
        router: Router,
        moduleBuilder: ModuleBuilderProtocol
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
    }
}

extension AuthPresenter: AuthPresenterProtocol {
    func viewDidLoad() {
        
    }
    
    func didTapVkButton() {
        authService?.wakeUpSession()
    }
}
