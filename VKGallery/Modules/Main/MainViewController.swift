//
//  MainViewController.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import UIKit

// MARK: - MainViewControllerProtocol
protocol MainViewControllerProtocol: AnyObject {
    func setupViewController(with model: [PhotoViewModel])
}

class MainViewController: UIViewController {
// MARK: - UI
    private lazy var barButtonItem = UIBarButtonItem(title: "Выход",
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(didTapBarButton)
    )
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //TODO: - подсчитать размеры под все экраны
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40) / 2 , height: 214)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        return collectionView
    }()
    
// MARK: - Variables
    var presenter: MainPresenterProtocol?
    private var viewModels: [PhotoViewModel] = []

// MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavBar()
    }
    
// MARK: - Objc methods
    @objc
    private func didTapBarButton() {
        presenter?.didTapLogOutButton()
    }
}

// MARK: - UICollectionViewDelegate impl
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTapCell(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDataSource impl
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else { fatalError("")
        }
        cell.configureCell(with: viewModels[indexPath.row])
        return cell
    }
}

// MARK: - MainViewControllerProtocol impl
extension MainViewController: MainViewControllerProtocol {
    func setupViewController(with model: [PhotoViewModel]) {
        viewModels = model
        collectionView.reloadData()
    }
}

// MARK: - private methods
private extension MainViewController {
    func setupNavBar() {
        title = "MobileUp Gallery"
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
        presenter?.viewDidLoad()
    }
    
    func addSubviews() {
        view.addSubview(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

