import SwiftUI

struct MyNFTView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: MyNFTViewModel
    @State private var isSortDialogPresented = false

    init(viewModel: MyNFTViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .background(.whiteYP)
            .navigationBarBackButtonHidden(true)
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

                ToolbarItem(placement: .principal) {
                    Text("Мои NFT")
                        .font(.bodyBold)
                        .foregroundStyle(.blackYP)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        guard !viewModel.nfts.isEmpty else {
                            return
                        }

                        isSortDialogPresented = true
                    } label: {
                        Image("sortYP")
                            .resizable()
                            .frame(width: 42, height: 42)
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.nfts.isEmpty)
                    .opacity(viewModel.nfts.isEmpty ? 0 : 1)
                }
            }
            .confirmationDialog(
                "Сортировка",
                isPresented: $isSortDialogPresented,
                titleVisibility: .visible
            ) {
                Button(MyNFTViewModel.SortOption.price.title) {
                    viewModel.applySort(.price)
                }

                Button(MyNFTViewModel.SortOption.rating.title) {
                    viewModel.applySort(.rating)
                }

                Button(MyNFTViewModel.SortOption.name.title) {
                    viewModel.applySort(.name)
                }

                Button("Закрыть", role: .cancel) {}
            }
            .task {
                await viewModel.loadNFTs()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded:
            nftList

        case .empty:
            emptyView

        case .failed(let message):
            errorView(message)
        }
    }

    private var nftList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.nfts) { nft in
                    MyNFTRowView(nft: nft)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
    }

    private var emptyView: some View {
        Text("У Вас ещё нет NFT")
            .font(.bodyBold)
            .foregroundStyle(.blackYP)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.bodyRegular)
                .foregroundStyle(.blackYP)

            Button("Повторить") {
                Task {
                    await viewModel.retry()
                }
            }
            .font(.bodySemibold)
            .foregroundStyle(.blueUniversalYP)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
private final class MockMyNFTProfileService: ProfileService {
    func loadProfile() async throws -> Profile {
        Profile(
            id: "profile",
            name: "John Doe",
            avatar: "",
            description: "",
            website: "",
            nfts: ["lilo", "spring", "april"],
            likes: []
        )
    }

    func updateProfile(_ profile: Profile) async throws -> Profile {
        profile
    }
}

private final class MockEmptyMyNFTProfileService: ProfileService {
    func loadProfile() async throws -> Profile {
        Profile(
            id: "profile",
            name: "John Doe",
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

private final class MockMyNFTService: NftService {
    func loadNft(id: String) async throws -> Nft {
        switch id {
        case "lilo":
            Nft(
                id: "lilo",
                name: "Lilo",
                images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/1.png")!],
                rating: 3,
                price: 1.78,
                author: "John Doe"
            )

        case "spring":
            Nft(
                id: "spring",
                name: "Spring",
                images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/2.png")!],
                rating: 3,
                price: 1.78,
                author: "John Doe"
            )

        default:
            Nft(
                id: "april",
                name: "April",
                images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/3.png")!],
                rating: 3,
                price: 1.78,
                author: "John Doe"
            )
        }
    }
}

#Preview("Мои NFT") {
    NavigationStack {
        MyNFTView(
            viewModel: MyNFTViewModel(
                profileService: MockMyNFTProfileService(),
                nftService: MockMyNFTService()
            )
        )
    }
}

#Preview("Нет NFT") {
    NavigationStack {
        MyNFTView(
            viewModel: MyNFTViewModel(
                profileService: MockEmptyMyNFTProfileService(),
                nftService: MockMyNFTService()
            )
        )
    }
}
#endif
