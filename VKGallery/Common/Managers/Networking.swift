import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(urlString: String) async throws -> T
}

public final class NetworkManager {
    private let jsonService: JSONDecoderManagerProtocol
    init(jsonService: JSONDecoderManagerProtocol) {
        self.jsonService = jsonService
    }
}

//MARK: - NetworkManagerProtocol
extension NetworkManager: NetworkManagerProtocol {
    func request<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw AppError.networking
        }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try jsonService.decode(data)
    }
}
