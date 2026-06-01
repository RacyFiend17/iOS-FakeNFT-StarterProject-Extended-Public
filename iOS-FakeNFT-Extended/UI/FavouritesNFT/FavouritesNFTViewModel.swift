import Foundation

@MainActor
@Observable
final class FavouritesNFTViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case failed(String)
    }

    private let profileService: ProfileService
    private let nftService: NftService

    var state: State = .idle
    var nfts: [Nft] = []
    var isUpdatingLikes = false

    private var profile: Profile?

    init(
        profileService: ProfileService,
        nftService: NftService
    ) {
        self.profileService = profileService
        self.nftService = nftService
    }

    func loadFavourites() async {
        state = .loading

        do {
            let profile = try await profileService.loadProfile()
            self.profile = profile

            guard !profile.likes.isEmpty else {
                nfts = []
                state = .empty
                return
            }

            var loadedNFTs: [Nft] = []

            for nftId in profile.likes {
                let nft = try await nftService.loadNft(id: nftId)
                loadedNFTs.append(nft)
            }

            nfts = loadedNFTs
            state = nfts.isEmpty ? .empty : .loaded
        } catch {
            state = .failed("Не удалось загрузить избранные NFT")
        }
    }

    func retry() async {
        await loadFavourites()
    }

    func removeFromFavourites(_ nft: Nft) async -> Profile? {
        guard !isUpdatingLikes else {
            return nil
        }

        guard let currentProfile = profile else {
            return nil
        }

        isUpdatingLikes = true

        let previousProfile = profile
        let previousNFTs = nfts
        let previousState = state

        let updatedLikes = currentProfile.likes.filter { $0 != nft.id }

        let updatedProfile = Profile(
            id: currentProfile.id,
            name: currentProfile.name,
            avatar: currentProfile.avatar,
            description: currentProfile.description,
            website: currentProfile.website,
            nfts: currentProfile.nfts,
            likes: updatedLikes
        )

        nfts.removeAll { $0.id == nft.id }
        profile = updatedProfile
        state = nfts.isEmpty ? .empty : .loaded

        do {
            let savedProfile = try await profileService.updateProfile(updatedProfile)
            profile = savedProfile
            isUpdatingLikes = false
            return savedProfile
        } catch {
            profile = previousProfile
            nfts = previousNFTs
            state = previousState
            isUpdatingLikes = false
            return nil
        }
    }
}
