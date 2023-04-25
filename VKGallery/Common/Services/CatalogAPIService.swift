import Foundation

protocol APIServiceProtocol {
    func fetchPhotos() async throws -> AlbumResponseModel
}

final class APIService {
    private let networkManager: NetworkManagerProtocol
    private let serviceKey = "a2d70a25a2d70a25a2d70a25dda1c4a41faa2d7a2d70a25c6967059a0f9d20767bef97a"
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension APIService: APIServiceProtocol {
    func fetchPhotos() async throws -> AlbumResponseModel {
        let url = getUrl()
        let urlString = url
        return try await networkManager.request(urlString: urlString)
    }
}

private extension APIService {
    func getUrl() -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/photos.get"
        
        components.queryItems = [
            URLQueryItem(name: "owner_id", value: "-128666765"),
            URLQueryItem(name: "album_id", value: "266310117"),
            URLQueryItem(name: "access_token", value: serviceKey),
            URLQueryItem(name: "v", value: "5.131"),
        ]
        guard let url = components.url?.absoluteString else {
            fatalError()
        }
        return url
    }
}

