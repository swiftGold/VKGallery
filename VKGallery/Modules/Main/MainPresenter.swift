//
//  MainPresenter.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import VK_ios_sdk

protocol MainPresenterProtocol {
    func viewDidLoad()
    func didTapCell(at index: Int)
    func didTapLogOutButton()
}

final class MainPresenter {
    weak var viewController: MainViewControllerProtocol?
    
    private var viewModels: [PhotoViewModel] = []
    
    private let router: Router
    private let moduleBuilder: ModuleBuilderProtocol
    private let apiService: APIServiceProtocol
    
    
    init(
        router: Router,
        moduleBuilder: ModuleBuilderProtocol,
        apiService: APIServiceProtocol
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
        self.apiService = apiService
    }
}

extension MainPresenter: MainPresenterProtocol {
    func didTapLogOutButton() {
        VKSdk.forceLogout()
        print("doljet razloginit'")
        let authViewController = moduleBuilder.buildAuthViewController()
        router.push(authViewController, animated: true)
    }
    
    func viewDidLoad() {
        fetchPhotos()
    }
    
    func didTapCell(at index: Int) {
        let detailViewController = moduleBuilder.buildDetailViewController()
        router.push(detailViewController, animated: true)
    }
}

private extension MainPresenter {
    func fetchPhotos() {
        Task {
            do {
                let albumResponse = try await apiService.fetchPhotos()
                let itemsArray: [PhotoModel] = albumResponse.response.items
                viewModels = itemsArray.map { item in
                    let id = item.id
                    var url = ""
                    item.sizes.forEach { unit in
                        if unit.type == "q" {
                            url = unit.url
                        }
                    }
                    return PhotoViewModel(id: id, url: url)
                }
                await MainActor.run {
                    viewController?.setupViewController(with: viewModels)
                }
            } catch {
                await MainActor.run {
                    print(error, error.localizedDescription)
                }
            }
        }
    }
}
