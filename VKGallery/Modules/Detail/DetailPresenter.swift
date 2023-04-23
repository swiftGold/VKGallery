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
    private var alertManager: AlertManagerProtocol
    
    init(apiService: APIServiceProtocol,
         photoModel: DetailPhotoViewModel,
         photoModels: [DetailPhotoViewModel],
         calendarManager: CalendarManagerProtocol,
         alertManager: AlertManagerProtocol
    ) {
        self.apiService = apiService
        self.photoModel = photoModel
        self.photoModels = photoModels
        self.calendarManager = calendarManager
        self.alertManager = alertManager
    }
}

// MARK: - DetailPresenterProtocol impl
extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        viewController?.showPlaceholders()
        viewController?.setupImageView(with: photoModel)
        viewController?.setupCollectionView(with: photoModels)
    }
    
    func didTapCell(at index: Int) {
        let model = photoModels[index]
        viewController?.setupImageView(with: model)
    }
    
    func didTapShareButton(with image: UIImage?) {
        if let image = image {
            let shareViewController = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil
            )
            shareViewController.completionWithItemsHandler = { _, bool, _, _ in
                if bool {
                    self.alertManager.showAlertWithVC(title: "alert.success.savepicture.title".localized,
                                                      message: "alert.success.savepicture.message".localized,
                                                      vc: self.viewController
                    )
                }
            }
            viewController?.present(shareViewController, animated: true, completion: nil)
        } else {
            alertManager.showAlertWithVC(title: "alert.failure.savepicture.title".localized,
                                         message: "alert.failure.savepicture.message".localized,
                                         vc: viewController
            )
        }
    }
}
