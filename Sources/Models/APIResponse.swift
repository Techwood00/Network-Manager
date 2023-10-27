
import Foundation

struct APIResponse<T: Decodable>: NetworkResponse {
    typealias ResponseType = T
}
