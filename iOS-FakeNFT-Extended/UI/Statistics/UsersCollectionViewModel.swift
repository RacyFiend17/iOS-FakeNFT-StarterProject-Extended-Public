import Foundation

@MainActor
final class UsersCollectionViewModel: ObservableObject {
    @Published private(set) var nfts: [Nft] = []
    @Published private(set) var state: UsersCollectionViewState = .idle

    private let nftIDs: [String]

    init(user: StatisticsUser) {
        self.nftIDs = user.nfts
    }

    func loadNfts() {
        guard state != .loading, state != .loaded else { return }
        reloadNfts()
    }

    func reloadNfts() {
        state = .loading
        nfts = StatisticsMockNftData.nfts(for: nftIDs)
        state = .loaded
    }
}
