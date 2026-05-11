import Foundation

struct Nft: Decodable, Sendable {
    let id: String
    let name: String
    let imagesUrls: [URL]
    let rating: Int
    let price: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imagesUrls = "images"
        case rating
        case price
    }
}

// MARK: - Mocks

extension Nft {
    static let mock1 = Nft(
        id: "1",
        name: "April",
        imagesUrls: [],
        rating: 3,
        price: 1.5
    )
    
    static let mock2 = Nft(
        id: "2",
        name: "Luna",
        imagesUrls: [],
        rating: 5,
        price: 2.25
    )
    
    static let mock3 = Nft(
        id: "3",
        name: "Cherry",
        imagesUrls: [],
        rating: 1,
        price: 0.75
    )
}
