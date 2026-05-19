import Foundation

@MainActor
@Observable
final class MyNFTViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case failed(String)
    }

    enum SortOption: String, CaseIterable, Identifiable {
        case price
        case rating
        case name

        var id: String {
            rawValue
        }

        var title: String {
            switch self {
            case .price:
                "По цене"
            case .rating:
                "По рейтингу"
            case .name:
                "По названию"
            }
        }
    }

    private let profileService: ProfileService
    private let nftService: NftService

    var state: State = .idle
    var nfts: [Nft] = []
    var selectedSortOption: SortOption?

    init(
        profileService: ProfileService,
        nftService: NftService
    ) {
        self.profileService = profileService
        self.nftService = nftService
    }

    func loadNFTs() async {
        state = .loading

        do {
            let profile = try await profileService.loadProfile()

            guard !profile.nfts.isEmpty else {
                nfts = []
                state = .empty
                return
            }

            var loadedNFTs: [Nft] = []

            for nftId in profile.nfts {
                let nft = try await nftService.loadNft(id: nftId)
                loadedNFTs.append(nft)
            }

            nfts = sort(loadedNFTs)
            state = nfts.isEmpty ? .empty : .loaded
        } catch {
            state = .failed("Не удалось загрузить NFT")
        }
    }

    func retry() async {
        await loadNFTs()
    }

    func applySort(_ option: SortOption) {
        guard !nfts.isEmpty else {
            return
        }

        selectedSortOption = option
        nfts = sort(nfts)
        state = .loaded
    }

    private func sort(_ nfts: [Nft]) -> [Nft] {
        guard let selectedSortOption else {
            return nfts
        }

        switch selectedSortOption {
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        case .name:
            return nfts.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
}
