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

final class DetailPresenter {
    weak var viewController: DetailViewController?
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        
    }
    
    func didTapCell(at index: Int) {
        
    }
}
