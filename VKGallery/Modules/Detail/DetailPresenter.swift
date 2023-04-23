//
//  DetailPresenter.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import UIKit

protocol DetailPresenterProtocol {
    func viewDidLoad()
    func didTapCell(at index: Int)
    func didTapShareButton(with image: UIImage?)
}

// MARK: - DetailPresenter
final class DetailPresenter {
    weak var viewController: DetailViewController?
    
    private var apiService: APIServiceProtocol
    private var photoModel: DetailPhotoViewModel
    private var photoModels: [DetailPhotoViewModel]
    private var calendarManager: CalendarManagerProtocol
    private let imageSave = ImageSavePhotosAlbum()
    private var alert: AlertsProtocol
    
    init(apiService: APIServiceProtocol,
         photoModel: DetailPhotoViewModel,
         photoModels: [DetailPhotoViewModel],
         calendarManager: CalendarManagerProtocol,
         alert: AlertsProtocol
    ) {
        self.apiService = apiService
        self.photoModel = photoModel
        self.photoModels = photoModels
        self.calendarManager = calendarManager
        self.alert = alert
    }
}

// MARK: - DetailPresenterProtocol impl
extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        viewController?.showPlaceholders()
        //Only for placeholder show :)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.viewController?.setupImageView(with: self.photoModel)
            self.viewController?.setupCollectionView(with: self.photoModels)
        }
    }
    
    func didTapCell(at index: Int) {
        let model = photoModels[index]
        viewController?.setupImageView(with: model)
    }
    
    func didTapShareButton(with image: UIImage?) {
        if let image = image {
            imageSave.writeToPhotoAlbum(image: image)
            let alert = alert.showAlertWith(
                title: "alert.success.savepicture.title".localized,
                message: "alert.success.savepicture.message".localized
            )
            viewController?.imageSuccessSaved(with: alert)
        } else {
            let alert = alert.showAlertWith(
                title: "alert.failure.savepicture.title".localized,
                message: "alert.failure.savepicture.message".localized
            )
            viewController?.imageFailureSaved(with: alert)
        }
    }
}
