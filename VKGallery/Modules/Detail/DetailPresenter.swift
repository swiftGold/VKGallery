//
//  DetailPresenter.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

protocol DetailPresenterProtocol {
    func viewDidLoad()
    func didTapCell(at index: Int)
}

// MARK: - DetailPresenter
final class DetailPresenter {
    weak var viewController: DetailViewController?
    
    private var apiService: APIServiceProtocol
    private var photoModel: DetailPhotoViewModel
    private var photoModels: [DetailPhotoViewModel]
    private var calendarManager: CalendarManagerProtocol
    
    init(apiService: APIServiceProtocol,
         photoModel: DetailPhotoViewModel,
         photoModels: [DetailPhotoViewModel],
         calendarManager: CalendarManagerProtocol
    ) {
        self.apiService = apiService
        self.photoModel = photoModel
        self.photoModels = photoModels
        self.calendarManager = calendarManager
    }
}

// MARK: - DetailPresenterProtocol impl
extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        viewController?.setupImageView(with: photoModel)
        viewController?.setupCollectionView(with: photoModels)
    }
    
    func didTapCell(at index: Int) {
        let model = photoModels[index]
        viewController?.setupImageView(with: model)
    }
}
