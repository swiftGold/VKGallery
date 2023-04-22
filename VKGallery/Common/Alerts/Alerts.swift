//
//  Alerts.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 22.04.2023.
//

import UIKit

protocol AlertsProtocol {
    func showAlertWith(title: String, message: String) -> UIAlertController 
}

final class Alerts {}

extension Alerts: AlertsProtocol {
    func showAlertWith(title: String, message: String) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        return ac
    }
}
