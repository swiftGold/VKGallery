//
//  AuthViewController.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 20.04.2023.
//

import UIKit

// MARK: - AuthViewControllerProtocol
protocol AuthViewControllerProtocol: UIViewController {}

class AuthViewController: UIViewController {
// MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.SFBold, size: 44)
        label.text = "Mobile Up Gallery"
        label.textColor = UIColor(named: Colors.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var vkButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapVkButton), for: .touchUpInside)
        button.setTitle("button.login".localized, for: .normal)
        button.setTitleColor(UIColor(named: Colors.white), for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.SFRegular, size: 15)
        button.backgroundColor = UIColor(named: Colors.black)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
// MARK: - Variables
    var presenter: AuthPresenterProtocol?
    
// MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
// MARK: - objc methods
    @objc
    private func didTapVkButton() {
        presenter?.didTapVkButton()
    }
}

// MARK: - AuthViewControllerProtocol impl
extension AuthViewController: AuthViewControllerProtocol {}

// MARK: - private methods
private extension AuthViewController {
    func setupViewController() {
        view.backgroundColor = UIColor(named: Colors.white)
        
        addSubviews()
        setConstraints()
        presenter?.viewDidLoad()
    }
    
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(vkButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            vkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            vkButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
