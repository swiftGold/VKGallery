//
//  MainPresenter.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

protocol MainPresenterProtocol {
    func viewDidLoad()
    func didTapCell(at index: Int)
}

final class MainPresenter {
    weak var viewController: MainViewControllerProtocol?
    
    private let router: Router
    private let moduleBuilder: ModuleBuilderProtocol
    
    init(
        router: Router,
        moduleBuilder: ModuleBuilderProtocol
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
    }
}

extension MainPresenter: MainPresenterProtocol {
    func viewDidLoad() {
        
    }
    
    func didTapCell(at index: Int) {
        let detailViewController = moduleBuilder.buildDetailViewController()
        router.push(detailViewController, animated: true)
    }
}
