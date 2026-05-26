import Foundation

@MainActor
final class UsersCollectionViewModel: ObservableObject {
    @Published private(set) var nfts: [Nft] = []
    @Published private(set) var state: UsersCollectionViewState = .idle

    private let nftIDs: [String]

    init(user: StatisticsUser) {
        self.nftIDs = user.nfts
    }

    func loadNfts(service: CollectionServiceProtocol) async {
        guard state != .loading, state != .loaded else { return }
        await reloadNfts(service: service)
    }

    func reloadNfts(service: CollectionServiceProtocol) async {
        state = .loading

        do {
            nfts = try await service.loadNfts(ids: nftIDs)
            state = .loaded
        } catch {
            state = .failed
        }
    }
}
