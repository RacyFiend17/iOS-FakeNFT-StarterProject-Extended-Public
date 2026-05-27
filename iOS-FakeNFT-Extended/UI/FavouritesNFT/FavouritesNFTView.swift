import SwiftUI

struct FavouritesNFTView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: FavouritesNFTViewModel

    let onLikesChanged: (Profile) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 7, alignment: .top),
        GridItem(.flexible(), spacing: 7, alignment: .top)
    ]

    init(
        viewModel: FavouritesNFTViewModel,
        onLikesChanged: @escaping (Profile) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onLikesChanged = onLikesChanged
    }

    var body: some View {
        content
            .background(.whiteYP)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 28, weight: .regular))
                            .foregroundStyle(.blackYP)
                    }
                    .buttonStyle(.plain)
                }

                if viewModel.state == .loaded {
                    ToolbarItem(placement: .principal) {
                        Text("Избранные NFT")
                            .font(.bodyBold)
                            .foregroundStyle(.blackYP)
                    }
                }
            }
            .task {
                if viewModel.state == .idle {
                    await viewModel.loadFavourites()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .tint(.blackYP)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded:
            favouritesGrid

        case .empty:
            emptyView

        case .failed(let message):
            errorView(message)
        }
    }

    private var favouritesGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: 16
            ) {
                ForEach(viewModel.nfts) { nft in
                    FavouriteNFTCellView(
                        nft: nft,
                        isUpdatingLikes: viewModel.isUpdatingLikes
                    ) {
                        Task {
                            if let updatedProfile = await viewModel.removeFromFavourites(nft) {
                                onLikesChanged(updatedProfile)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
        .background(.whiteYP)
    }

    private var emptyView: some View {
        Text("У Вас ещё нет избранных NFT")
            .font(.bodyBold)
            .foregroundStyle(.blackYP)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.bodyRegular)
                .foregroundStyle(.blackYP)
                .multilineTextAlignment(.center)

            Button("Повторить") {
                Task {
                    await viewModel.retry()
                }
            }
            .font(.bodySemibold)
            .foregroundStyle(.blueUniversalYP)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct FavouriteNFTCellView: View {
    let nft: Nft
    let isUpdatingLikes: Bool
    let onLikeTap: () -> Void

    private let imageSize: CGFloat = 80

    var body: some View {
        HStack(spacing: 12) {
            nftImage

            VStack(alignment: .leading, spacing: 0) {
                Text(nft.name)
                    .font(.bodyBold)
                    .foregroundStyle(.blackYP)
                    .lineLimit(1)

                ratingView
                    .padding(.top, 4)

                Text(priceText)
                    .font(.caption3)
                    .foregroundStyle(.blackYP)
                    .lineLimit(1)
                    .padding(.top, 8)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: imageSize)
    }

    private var nftImage: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: nft.images.first) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: imageSize, height: imageSize)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                case .failure:
                    Image("nftStubYP")
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                @unknown default:
                    Image("nftStubYP")
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            Button(action: onLikeTap) {
                Image("likeYP")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.redUniversalYP)
                    .padding(8)
            }
            .buttonStyle(.plain)
            .disabled(isUpdatingLikes)
            .opacity(isUpdatingLikes ? 0.6 : 1)
        }
        .frame(width: imageSize, height: imageSize)
    }

    private var ratingView: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image("starYP")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(index <= nft.rating ? .yellowUniversalYP : .grayLightYP)
            }
        }
        .frame(height: 12)
    }

    private var priceText: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: nft.price)
        let formattedPrice = formatter.string(from: number) ?? "\(nft.price)"

        return "\(formattedPrice) ETH"
    }
}

#if DEBUG
private final class MockFavouritesProfileService: ProfileService {
    func loadProfile() async throws -> Profile {
        Profile(
            id: "profile",
            name: "Joaquin Phoenix",
            avatar: "",
            description: "",
            website: "",
            nfts: [],
            likes: ["1", "2", "3", "4", "5", "6"]
        )
    }

    func updateProfile(_ profile: Profile) async throws -> Profile {
        profile
    }
}

private final class MockEmptyFavouritesProfileService: ProfileService {
    func loadProfile() async throws -> Profile {
        Profile(
            id: "profile",
            name: "Joaquin Phoenix",
            avatar: "",
            description: "",
            website: "",
            nfts: [],
            likes: []
        )
    }

    func updateProfile(_ profile: Profile) async throws -> Profile {
        profile
    }
}

private final class MockFavouritesNFTService: NftService {
    func loadNft(id: String) async throws -> Nft {
        let index = Int(id) ?? 1
        let imageNumber = ((index - 1) % 3) + 1

        return Nft(
            id: id,
            name: "NFT-\(id)",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/\(imageNumber).png")!
            ],
            rating: min(index, 5),
            price: Double(index) * 0.42,
            author: "John Doe"
        )
    }
}

#Preview("Избранные NFT") {
    NavigationStack {
        FavouritesNFTView(
            viewModel: FavouritesNFTViewModel(
                profileService: MockFavouritesProfileService(),
                nftService: MockFavouritesNFTService()
            ),
            onLikesChanged: { _ in }
        )
    }
}

#Preview("Нет избранных NFT") {
    NavigationStack {
        FavouritesNFTView(
            viewModel: FavouritesNFTViewModel(
                profileService: MockEmptyFavouritesProfileService(),
                nftService: MockFavouritesNFTService()
            ),
            onLikesChanged: { _ in }
        )
    }
}
#endif
