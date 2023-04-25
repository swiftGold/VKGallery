//
//  ModuleBuilder.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

protocol ModuleBuilderProtocol {
    func buildAuthViewController() -> AuthViewController
    func buildMainViewController() -> MainViewController
    func buildDetailViewController(model: DetailPhotoViewModel, models: [DetailPhotoViewModel]) -> DetailViewController
    func buildWebViewViewController() -> WebViewViewController
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
        let loginVKManager = LoginVKManager()
        let presenter = AuthPresenter(router: router,
                                      moduleBuilder: self,
                                      loginVKManager: loginVKManager
        )
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
    
    func buildMainViewController() -> MainViewController {
        let viewController = MainViewController()
        let loginVkManager = LoginVKManager()
        let alertManager = AlertManager()
        let calendarManager = CalendarManager()
        let jsonService = JSONDecoderManager()
        let networkManager = NetworkManager(jsonService: jsonService)
        let apiService = APIService(networkManager: networkManager)
        let presenter = MainPresenter(router: router,
                                      moduleBuilder: self,
                                      apiService: apiService,
                                      calendarManager: calendarManager,
                                      alertManager: alertManager,
                                      loginVkManager: loginVkManager
        )
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
    
    func buildDetailViewController(model: DetailPhotoViewModel, models: [DetailPhotoViewModel]) -> DetailViewController {
        let viewController = DetailViewController()
        let alertManager = AlertManager()
        let calendarManager = CalendarManager()
        let jsonService = JSONDecoderManager()
        let networkManager = NetworkManager(jsonService: jsonService)
        let apiService = APIService(networkManager: networkManager)
        let presenter = DetailPresenter(apiService: apiService,
                                        photoModel: model,
                                        photoModels: models,
                                        calendarManager: calendarManager,
                                        alertManager: alertManager
        )
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
    
    func buildWebViewViewController() -> WebViewViewController {
        let viewController = WebViewViewController()
        let alertManager = AlertManager()
        let loginVkManager = LoginVKManager()
        let presenter = WebViewPresenter(router: router,
                                         moduleBuilder: self,
                                         loginVKManager: loginVkManager,
                                         alertManager: alertManager
        )
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
