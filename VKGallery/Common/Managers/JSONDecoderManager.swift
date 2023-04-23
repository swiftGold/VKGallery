import Foundation

protocol JSONDecoderManagerProtocol {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

final class JSONDecoderManager {}

//MARK: - JSONDecoderManagerProtocol
extension JSONDecoderManager: JSONDecoderManagerProtocol {
    func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw AppError.decoding
        }
    }
}

