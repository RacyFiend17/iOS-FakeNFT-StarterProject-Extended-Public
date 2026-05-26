import Foundation

struct Nft: Decodable, Sendable, Identifiable, Equatable {
    let id: String
    let name: String
    let imagesUrls: [URL]
    let rating: Int
    let price: Double
    let author: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id, name, rating, price, author, description
        case imagesUrls = "images"
    }
}

// MARK: - Mocks

extension Nft {
    static let mock1 = Nft(
        id: "1",
        name: "April",
        imagesUrls: [],
        rating: 3,
        price: 1.5,
        author: "Author 1",
        description: "Description 1"
    )
    
    static let mock2 = Nft(
        id: "2",
        name: "Luna",
        imagesUrls: [],
        rating: 5,
        price: 2.25,
        author: "Author 2",
        description: "Description 2"
    )
    
    static let mock3 = Nft(
        id: "3",
        name: "Cherry",
        imagesUrls: [],
        rating: 1,
        price: 0.75,
        author: "Author 3",
        description: "Description 3"
    )
}
