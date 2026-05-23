import Foundation

struct Nft: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
    let author: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case images
        case rating
        case price
        case author
    }

    init(
        id: String,
        name: String,
        images: [URL],
        rating: Int,
        price: Double,
        author: String
    ) {
        self.id = id
        self.name = name
        self.images = images
        self.rating = rating
        self.price = price
        self.author = author
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        images = try container.decodeIfPresent([URL].self, forKey: .images) ?? []
        rating = try container.decodeIfPresent(Int.self, forKey: .rating) ?? 0
        price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0
        author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
    }
}
