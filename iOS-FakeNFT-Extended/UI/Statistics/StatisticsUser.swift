import Foundation

struct StatisticsUser: Identifiable, Hashable {
    let id: String
    let name: String
    let avatarURL: URL?
    let rating: Int
}
