//
//  Alerts.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 22.04.2023.
//

import UIKit

protocol AlertManagerProtocol {
    func showAlertWith(title: String, message: String) -> UIAlertController
    func showAlertWithVC(title: String, message: String, vc: UIViewController?)
}

final class AlertManager {}

extension AlertManager: AlertManagerProtocol {
    func showAlertWith(title: String, message: String) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        return ac
    }
    
    func showAlertWithVC(title: String, message: String, vc: UIViewController?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        vc?.present(ac, animated: true)
    }
}
