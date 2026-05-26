import Foundation

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/users")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "0"),
            URLQueryItem(name: "size", value: "100")
        ]
        return components?.url
    }
}
