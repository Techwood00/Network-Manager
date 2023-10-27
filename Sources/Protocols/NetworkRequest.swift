
import Foundation

protocol NetworkRequest {
    var endpoint: URL { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}
