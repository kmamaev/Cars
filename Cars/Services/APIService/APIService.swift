import Foundation

class APIService {
    private let session: URLSession
    private let host: String
    
    var additionalParamaters: [URLQueryItem] = []
    
    init(host: String) {
        self.host = host
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func runTask<ResponseType: Decodable>(context: RequestContext, completion: @escaping (Result<ResponseType, Error>) -> ()) -> URLSessionDataTask? {
        do {
            let urlRequest = try builtUrlRequest(from: context)
            #warning("replace with logging")
            print("Request: \(urlRequest.url?.absoluteString ?? "")")
            let task = session.dataTask(with: urlRequest) {(data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                            completion(.failure(APIError.emptyData))
                        }
                    return
                }
                print("Response: \(String(data: data, encoding: .utf8)!)")
                do {
                    let decodedResponse = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                            completion(.success(decodedResponse))
                        }
                } catch {
                    DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                }
            }
            task.resume()
            return task
        } catch {
            DispatchQueue.main.async {
                    completion(.failure(error))
                }
        }
        return nil
    }
}

private extension APIService {
    func builtUrlRequest(from context: RequestContext) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = host
        urlComponents.path = context.apiMethod
        urlComponents.queryItems = context.parameters + additionalParamaters
        guard let urlWithParameters = urlComponents.url else {
            throw APIError.malformedURL
        }
        
        var urlRequest = URLRequest(url: urlWithParameters)
        urlRequest.httpMethod = context.httpMethod.stringRepresentation
        urlRequest.httpBody = context.httpBody

        return urlRequest
    }
}

private extension HTTPMethod {
    var stringRepresentation: String {
        switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .delete: return "DELETE"
        }
    }
}
