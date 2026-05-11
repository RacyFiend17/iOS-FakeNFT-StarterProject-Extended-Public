import Foundation

final class StatisticsViewModel: ObservableObject {
    @Published private(set) var users: [StatisticsUser]
    @Published private(set) var sortOption: StatisticsSortOption

    var sortedUsers: [StatisticsUser] {
        switch sortOption {
        case .rating:
            return users.sorted { $0.rating > $1.rating }
        case .name:
            return users.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }

    init(
        users: [StatisticsUser] = StatisticsMockData.users,
        sortOption: StatisticsSortOption = .rating
    ) {
        self.users = users
        self.sortOption = sortOption
    }

    func sortByName() {
        sortOption = .name
    }

    func sortByRating() {
        sortOption = .rating
    }
}
