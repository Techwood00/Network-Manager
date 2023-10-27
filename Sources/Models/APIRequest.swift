
import Foundation

struct APIRequest: NetworkRequest {
    let endpoint: URL
    let method: HTTPMethod
    let parameters: [String: Any]?
    let headers: [String: String]?
}
