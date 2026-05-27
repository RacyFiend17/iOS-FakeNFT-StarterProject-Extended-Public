import Foundation

@MainActor
final class UsersCollectionViewModel: ObservableObject {
    @Published private(set) var nfts: [Nft] = []
    @Published private(set) var state: UsersCollectionViewState = .idle
    @Published var errorMessage: String?

    private let nftIDs: [String]
    private let favoritesSyncService: FavoritesSyncService

    init(
        user: StatisticsUser,
        favoritesSyncService: FavoritesSyncService? = nil
    ) {
        self.nftIDs = user.nfts
        self.favoritesSyncService = favoritesSyncService ?? ProfileFavoritesSyncService(
            profileService: ProfileServiceImpl(
                networkClient: DefaultNetworkClient()
            )
        )
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
    
    func updateProfileLike(nftId: String, isLiked: Bool) async {
        errorMessage = nil

        do {
            try await favoritesSyncService.updateProfileLike(
                nftId: nftId,
                isLiked: isLiked
            )
        } catch {
            errorMessage = "Не удалось обновить избранное"
        }
    }
}
