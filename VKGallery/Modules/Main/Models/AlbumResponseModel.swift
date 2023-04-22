//
//  AlbumResponseModel.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 21.04.2023.
//

struct AlbumResponseModel: Decodable {
    let response: ResponseDetails
}

struct ResponseDetails: Decodable {
    let items: [PhotoModel]
}

struct PhotoModel: Decodable {
    let date: Int
    let id: Int
    let sizes: [SizeDetails]
}

struct SizeDetails: Decodable {
    let type: String
    let url: String
}
