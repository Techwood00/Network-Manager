
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let maxRetryCount = 3
    
    func request<T: NetworkResponse>(_ request: NetworkRequest, responseType: T.Type, completion: @escaping (Result<T.ResponseType, Error>) -> Void) {
        performRequest(request, responseType: responseType, retryCount: 0, completion: completion)
    }
    
    private func performRequest<T: NetworkResponse>(
        _ request: NetworkRequest,
        responseType: T.Type,
        retryCount: Int,
        completion: @escaping (Result<T.ResponseType, Error>) -> Void
    ) {
        guard var components = URLComponents(url: request.endpoint, resolvingAgainstBaseURL: false) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        if request.method == .get, let parameters = request.parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
        }
        
        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if request.method == .post,
           let parameters = request.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                if retryCount < self.maxRetryCount {
                    // Retry the request
                    self.performRequest(request, responseType: responseType, retryCount: retryCount + 1, completion: completion)
                } else {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if retryCount < self.maxRetryCount {
                    // Retry the request
                    self.performRequest(request, responseType: responseType, retryCount: retryCount + 1, completion: completion)
                } else {
                    completion(.failure(NetworkError.requestFailed))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.ResponseType.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
