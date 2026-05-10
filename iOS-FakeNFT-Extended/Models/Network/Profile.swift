import Foundation

struct Profile: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
}
