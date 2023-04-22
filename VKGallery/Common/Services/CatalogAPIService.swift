protocol APIServiceProtocol {
    func fetchPhotos() async throws -> AlbumResponseModel
}

final class APIService {
    private let networkManager: NetworkManagerProtocol
    
    private let serviceKey = "a2d70a25a2d70a25a2d70a25dda1c4a41faa2d7a2d70a25c6967059a0f9d20767bef97a"
    private let ownerId = "-128666765"
    private let albumId = "266310117"
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension APIService: APIServiceProtocol {
    func fetchPhotos() async throws -> AlbumResponseModel {
        let urlString = "https://api.vk.com/method/photos.get?owner_id=\(ownerId)&album_id=\(albumId)&access_token=\(serviceKey)&v=5.131"
        return try await networkManager.request(urlString: urlString)
    }
}
