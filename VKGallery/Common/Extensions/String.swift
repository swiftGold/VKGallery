//
//  String.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 23.04.2023.
//

import Foundation

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
