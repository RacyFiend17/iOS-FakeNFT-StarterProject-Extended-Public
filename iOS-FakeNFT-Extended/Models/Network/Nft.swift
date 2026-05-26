import Foundation

struct Nft: Decodable, Identifiable, Hashable {
    let createdAt: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: String
    let id: String
}
