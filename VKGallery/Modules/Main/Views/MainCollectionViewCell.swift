//
//  MainCollectionViewCell.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: PhotoViewModel) {
        imageView.loadImage(from: model.url)
    }
    
    func configurePlaceholder() {
        imageView.image = UIImage(named: "placeHolder")
    }
}

// MARK: - Private methods

private extension MainCollectionViewCell {
    func setupCell() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(imageView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
