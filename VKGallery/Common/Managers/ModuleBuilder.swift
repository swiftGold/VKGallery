//
//  ModuleBuilder.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

protocol ModuleBuilderProtocol {
    func buildAuthViewController() -> AuthViewController
    func buildMainViewController() -> MainViewController
    func buildDetailViewController() -> DetailViewController
}

final class ModuleBuilder {
    private var router: Router
    private let apiservice: APIServiceProtocol
    private let networkManager: NetworkManagerProtocol
    private let decoderManager: JSONDecoderManagerProtocol
   
    init(router: Router) {
        self.router = router
        self.decoderManager = JSONDecoderManager()
        self.networkManager = NetworkManager(jsonService: decoderManager)
        self.apiservice = APIService(
            networkManager: networkManager)
    }
}

extension ModuleBuilder: ModuleBuilderProtocol {
    func buildAuthViewController() -> AuthViewController {
        let viewController = AuthViewController()
        let presenter = AuthPresenter(router: router, moduleBuilder: self)
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
    
    func buildMainViewController() -> MainViewController {
        let viewController = MainViewController()
        let jsonService = JSONDecoderManager()
        let networkManager = NetworkManager(jsonService: jsonService)
        let apiService = APIService(networkManager: networkManager)
        let presenter = MainPresenter(router: router,
                                      moduleBuilder: self,
                                      apiService: apiService
        )
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
    
    func buildDetailViewController() -> DetailViewController {
        let viewController = DetailViewController()
        let presenter = DetailPresenter()
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
}

