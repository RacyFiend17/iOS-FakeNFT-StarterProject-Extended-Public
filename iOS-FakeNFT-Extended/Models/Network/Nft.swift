import Foundation

struct Nft: Decodable, Sendable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
}

// MARK: - Mocks

extension Nft {
    static let mock1 = Nft(
        id: "1",
        name: "April",
        images: [],
        rating: 3,
        price: 1.5
    )
    
    static let mock2 = Nft(
        id: "2",
        name: "Luna",
        images: [],
        rating: 5,
        price: 2.25
    )
    
    static let mock3 = Nft(
        id: "3",
        name: "Cherry",
        images: [],
        rating: 1,
        price: 0.75
    )
}
