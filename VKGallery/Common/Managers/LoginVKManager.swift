//
//  LoginVKManager.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 24.04.2023.
//

import Foundation

protocol LoginVKManagerProtocol {
    func isAuth() -> Bool
    func logoutFromVK(completion: @escaping ()->())
}

final class LoginVKManager {
    private let defaults = UserDefaults.standard
}

extension LoginVKManager: LoginVKManagerProtocol {
    func isAuth() -> Bool {
        let accessToken = defaults.string(forKey: "access_token")
        let tokenExpirationDate = defaults.object(forKey: "expires_in")
        let currentDate = Date()
        guard accessToken != nil else { return false }
        guard let expirationDate: Date = tokenExpirationDate as? Date else { return false }
        
        return expirationDate > currentDate
    }
    
    func logoutFromVK(completion: @escaping ()->()) {
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "expires_in")
        completion()
    }
}
