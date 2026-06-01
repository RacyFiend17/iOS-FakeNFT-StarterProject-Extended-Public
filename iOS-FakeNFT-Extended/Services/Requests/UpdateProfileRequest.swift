import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let profile: Profile

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var headers: [String: String] {
        [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
    }

    var httpBody: Data? {
        var items: [(String, String)] = [
            ("name", profile.name),
            ("description", profile.description),
            ("avatar", profile.avatar),
            ("website", profile.website)
        ]

        if profile.likes.isEmpty {
            items.append(("likes", "null"))
        } else {
            profile.likes.forEach {
                items.append(("likes", $0))
            }
        }

        let body = items
            .map { key, value in
                "\(key.urlEncoded)=\(value.urlEncoded)"
            }
            .joined(separator: "&")

        return body.data(using: .utf8)
    }
}

private extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
