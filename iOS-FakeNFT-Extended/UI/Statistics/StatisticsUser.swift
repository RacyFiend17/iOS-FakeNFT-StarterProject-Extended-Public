import Foundation

struct StatisticsUser: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: Double

    var avatarURL: URL? {
        guard !avatar.isEmpty else { return nil }
        return URL(string: avatar)
    }

    var websiteURL: URL? {
        guard !website.isEmpty else { return nil }
        return URL(string: website)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatar
        case description
        case website
        case nfts
        case rating
    }

    init(
        id: String,
        name: String,
        avatar: String,
        description: String,
        website: String,
        nfts: [String],
        rating: Double
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.rating = rating
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        website = try container.decodeIfPresent(String.self, forKey: .website) ?? ""

        if let stringNfts = try? container.decodeIfPresent([String].self, forKey: .nfts) {
            nfts = stringNfts
        } else if let intNfts = try? container.decodeIfPresent([Int].self, forKey: .nfts) {
            nfts = intNfts.map(String.init)
        } else {
            nfts = []
        }

        if let doubleRating = try? container.decodeIfPresent(Double.self, forKey: .rating) {
            rating = doubleRating
        } else if let intRating = try? container.decodeIfPresent(Int.self, forKey: .rating) {
            rating = Double(intRating)
        } else if let stringRating = try? container.decodeIfPresent(String.self, forKey: .rating) {
            rating = Double(stringRating.replacingOccurrences(of: ",", with: ".")) ?? 0
        } else {
            rating = 0
        }
    }
}
