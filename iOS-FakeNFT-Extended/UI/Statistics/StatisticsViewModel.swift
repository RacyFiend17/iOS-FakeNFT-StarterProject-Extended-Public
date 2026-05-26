import Foundation

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published private(set) var users: [StatisticsUser] = []
    @Published private(set) var sortOption: StatisticsSortOption = .rating
    @Published private(set) var state: StatisticsViewState = .idle
    
    var sortedUsers: [StatisticsUser] {
        switch sortOption {
        case .rating:
            return users.sorted {
                if $0.nfts.count == $1.nfts.count {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                } else {
                    return $0.nfts.count > $1.nfts.count
                }
            }

        case .name:
            return users.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
    
    func loadUsers(service: UsersService) async {
        guard state != .loading, state != .loaded else { return }
        await reloadUsers(service: service)
    }
    
    func reloadUsers(service: UsersService) async {
        state = .loading

        do {
            users = try await service.loadUsers()
            state = .loaded
        } catch {
            if isCancellationError(error) {
                return
            }

            print("Users loading error:", error)
            state = .failed
        }
    }
    
    private func isCancellationError(_ error: Error) -> Bool {
        let nsError = error as NSError
        return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled
    }
    
    func sortByName() {
        sortOption = .name
    }
    
    func sortByRating() {
        sortOption = .rating
    }
}
