protocol APIServiceProtocol {
  
}

final class APIService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension APIService: APIServiceProtocol {
    
}
