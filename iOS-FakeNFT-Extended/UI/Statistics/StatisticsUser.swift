import Foundation

struct StatisticsUser: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: Int

    var avatarURL: URL? {
        guard !avatar.isEmpty else { return nil }
        return URL(string: avatar)
    }

    var websiteURL: URL? {
        guard !website.isEmpty else { return nil }
        return URL(string: website)
    }
}
