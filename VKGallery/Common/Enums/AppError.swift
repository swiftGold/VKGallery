//
//  AppError.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 23.04.2023.
//

enum AppError: Error {
    case decoding
    case networking
    case unknown

    var title: String {
        switch self {
        case .decoding:
            return "alert.failure.decoding.title".localized
        case .networking:
            return "alert.failure.networking.title".localized
        case .unknown:
            return "alert.failure.unknown.title".localized
        }
    }
    
    var message: String {
        switch self {
        case .decoding:
            return "alert.failure.decoding.message".localized
        case .networking:
            return "alert.failure.networking.message".localized
        case .unknown:
            return "alert.failure.unknown.message".localized
        }
    }
}
