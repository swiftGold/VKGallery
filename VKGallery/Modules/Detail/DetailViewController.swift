//
//  DetailViewController.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import UIKit

// MARK: - DetailViewControllerProtocol
protocol DetailViewControllerProtocol: UIViewController {
    func setupImageView(with model: DetailPhotoViewModel)
    func setupCollectionView(with models: [DetailPhotoViewModel])
    func imageSuccessSaved(with alert: UIAlertController)
    func imageFailureSaved(with alert: UIAlertController)
    func showPlaceholders()
}

class DetailViewController: UIViewController {
// MARK: - UI
    private lazy var barButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(didTapBarButton))
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "singlePlaceholder")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout
        )
        layout.itemSize = CGSize(width: 54 , height: 54)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DetailCollectionViewCell.self,
                                forCellWithReuseIdentifier: "DetailCollectionViewCell"
        )
        return collectionView
    }()
    
// MARK: - Variables
    var presenter: DetailPresenterProtocol?
    private var viewModels: [DetailPhotoViewModel] = []
    private var isPlaceholder = false
    
// MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavBar()
    }
    
// MARK: - Objc methods
    @objc
    private func didTapBarButton() {
        let image = imageView.image
        presenter?.didTapShareButton(with: image)
    }
}

// MARK: - UICollectionViewDelegate impl
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTapCell(at: indexPath.item)
        imageView.transform = CGAffineTransform.identity
    }
}

// MARK: - UICollectionViewDataSource impl
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isPlaceholder ? 20 : viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell else { fatalError("")
        }
        if isPlaceholder {
            cell.configurePlaceholder()
        } else {
            let viewModel = viewModels[indexPath.row]
            cell.configureCell(with: viewModel)
        }
        return cell
    }
}

// MARK: - DetailViewControllerProtocol impl
extension DetailViewController: DetailViewControllerProtocol {
    func setupCollectionView(with models: [DetailPhotoViewModel]) {
        isPlaceholder = false
        viewModels = models
        collectionView.reloadData()
    }
    
    func setupImageView(with model: DetailPhotoViewModel) {
        imageView.enableZoom()
        imageView.loadImage(from: model.url)
        title = model.date
    }
    
    func imageSuccessSaved(with alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func imageFailureSaved(with alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func showPlaceholders() {
        isPlaceholder = true
        collectionView.reloadData()
    }
}

// MARK: - private methods
private extension DetailViewController {
    func setupNavBar() {
        navigationItem.rightBarButtonItem = barButtonItem
        navigationController?.navigationBar.tintColor = UIColor(named: Colors.black)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: Colors.black) ?? .black]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: Fonts.SFBold, size: 17)!]
    }
    
    func setupViewController() {
        view.backgroundColor = UIColor(named: Colors.white)
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
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 6.5),
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


