import Foundation

struct RequestContext {
    var apiMethod: String = ""
    var httpMethod: HTTPMethod = .get
    var httpBody: Data?
    var parameters: [URLQueryItem] = []
}

enum HTTPMethod {
    case get
    case post
    case put
    case delete
}
