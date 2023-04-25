//
//  MainPresenter.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import Foundation
import WebKit

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
    private let loginVkManager: LoginVKManagerProtocol
    
    init(
        router: Router,
        moduleBuilder: ModuleBuilderProtocol,
        apiService: APIServiceProtocol,
        calendarManager: CalendarManagerProtocol,
        alertManager: AlertManagerProtocol,
        loginVkManager: LoginVKManagerProtocol
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
        self.apiService = apiService
        self.calendarManager = calendarManager
        self.alertManager = alertManager
        self.loginVkManager = loginVkManager
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    func didTapLogOutButton() {
        let alert = UIAlertController(
            title: "navbar.button.exit".localized,
            message: "",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "alert.exitFromAccount.title".localized, style: .default) { _ in
            self.logoutFromVk()
        })
        alert.addAction(UIAlertAction(title: "alert.changeUser.title".localized, style: .default) { _ in
            self.removeCookies()
            self.logoutFromVk()
        })
        alert.addAction(UIAlertAction(title: "alert.cancel.title".localized, style: .destructive) { _ in
            print("cancel")
        })
        viewController?.present(alert, animated: true)
    }
    
    func viewDidLoad() {
        viewController?.showPlaceholders()
        fetchPhotos()
    }
    
    func didTapCell(at index: Int) {
        mapPhotosArray()
        if !detailViewsModels.isEmpty {
            let model = detailViewsModels[index]
            let detailViewController = moduleBuilder.buildDetailViewController(
                model: model,
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
                mapInPhotoViewModel(with: albumResponse)
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
            let date = calendarManager.fetchStringFromTimeStamp(ti: item.date)
            let url = item.url
            return DetailPhotoViewModel(id: id,
                                        date: date,
                                        url: url
            )
        }
    }
    
// MARK: - delete token and expires time from UserDefaults
    func logoutFromVk() {
        loginVkManager.logoutFromVK { [weak self] in
            guard let self = self else { return }
            let authViewController = self.moduleBuilder.buildAuthViewController()
            self.router.push(authViewController, animated: true)
        }
    }
    
// MARK: - Clear Cookies
    func removeCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie: \(record) deleted")
            }
        }
    }
    
    func mapInPhotoViewModel(with model: AlbumResponseModel) {
        let itemsArray: [PhotoModel] = model.response.items
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
    }
}
