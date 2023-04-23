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

// MARK: - MainPresenter
final class MainPresenter {
    weak var viewController: MainViewControllerProtocol?
    
    private var viewModels: [PhotoViewModel] = []
    private var detailViewsModels: [DetailPhotoViewModel] = []
    private var calendarManager: CalendarManagerProtocol
    private let router: Router
    private let moduleBuilder: ModuleBuilderProtocol
    private let apiService: APIServiceProtocol
    private let alertManager: AlertManagerProtocol
    
    init(
        router: Router,
        moduleBuilder: ModuleBuilderProtocol,
        apiService: APIServiceProtocol,
        calendarManager: CalendarManagerProtocol,
        alertManager: AlertManagerProtocol
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
        self.apiService = apiService
        self.calendarManager = calendarManager
        self.alertManager = alertManager
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    func didTapLogOutButton() {
        VKSdk.forceLogout()
        let authViewController = moduleBuilder.buildAuthViewController()
        router.push(authViewController, animated: true)
    }
    
    func viewDidLoad() {
        viewController?.showPlaceholders()
        fetchPhotos()
    }
    
    func didTapCell(at index: Int) {
        mapPhotosArray()
        if !detailViewsModels.isEmpty {
            let model = detailViewsModels[index]
            let detailViewController = moduleBuilder.buildDetailViewController(model: model,
                                                                               models: detailViewsModels
            )
            router.push(detailViewController, animated: true)
        }
    }
}

// MARK: - Private methods
private extension MainPresenter {
    func fetchPhotos() {
        Task {
            do {
                let albumResponse = try await apiService.fetchPhotos()
                let itemsArray: [PhotoModel] = albumResponse.response.items
                viewModels = itemsArray.map { item in
                    let id = item.id
                    let date = item.date
                    var url = ""
                    item.sizes.forEach { unit in
                        if unit.type == "q" {
                            url = unit.url
                        }
                    }
                    return PhotoViewModel(id: id,
                                          date: date,
                                          url: url)
                }
                await MainActor.run {
                    viewController?.setupViewController(with: viewModels)
                }
            } catch {
                await MainActor.run {
                    guard let appError = error as? AppError else {
                        alertManager.showAlertWithVC(
                            title: AppError.unknown.title,
                            message: AppError.unknown.message,
                            vc: viewController
                        )
                        return
                    }
                    alertManager.showAlertWithVC(
                        title: appError.title,
                        message: appError.message,
                        vc: viewController
                    )
                }
            }
        }
    }
    
    func mapPhotosArray() {
        detailViewsModels = viewModels.map { item in
            let id = item.id
            let date = calendarManager.fetchDateFromTimeStamp(ti: item.date)
            let url = item.url
            return DetailPhotoViewModel(id: id,
                                        date: date,
                                        url: url
            )
        }
    }
}
