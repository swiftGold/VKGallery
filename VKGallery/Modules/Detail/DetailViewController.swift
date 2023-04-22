//
//  DetailViewController.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import UIKit

// MARK: - DetailViewControllerProtocol
protocol DetailViewControllerProtocol: AnyObject {
    func setupImageView(with model: DetailPhotoViewModel)
    func setupCollectionView(with models: [DetailPhotoViewModel])
    func imageSuccessSaved(with alert: UIAlertController)
    func imageFailureSaved(with alert: UIAlertController)
}

class DetailViewController: UIViewController {
    // MARK: - UI
    private lazy var barButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(didTapBarButton))
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "forTime")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //TODO: - подсчитать размеры под все экраны
        layout.itemSize = CGSize(width: 54 , height: 54)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        return collectionView
    }()
    
    // MARK: - Variables
    var presenter: DetailPresenterProtocol?
    private var viewModels: [DetailPhotoViewModel] = []
    
    // MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavBar()
    }
    
    // MARK: - Objc methods
    @objc
    private func didTapBarButton() {
        print(#function)
        let image = imageView.image
        presenter?.didTapShareButton(with: image)
    }
}

// MARK: - UICollectionViewDelegate impl
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTapCell(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDataSource impl
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell else { fatalError("")
        }
        cell.configureCell(with: viewModels[indexPath.item])
        return cell
    }
}

// MARK: - DetailViewControllerProtocol impl
extension DetailViewController: DetailViewControllerProtocol {
    func setupCollectionView(with models: [DetailPhotoViewModel]) {
        viewModels = models
        collectionView.reloadData()
    }
    
    func setupImageView(with model: DetailPhotoViewModel) {
        imageView.enableZoom()
        imageView.downloaded(from: model.url)
        title = model.date
    }
    
    func imageSuccessSaved(with alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func imageFailureSaved(with alert: UIAlertController) {
        present(alert, animated: true)
    }
}

// MARK: - private methods
private extension DetailViewController {
    func setupNavBar() {
        navigationItem.rightBarButtonItem = barButtonItem
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
        view.addSubview(imageView)
        view.addSubview(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 375),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}


