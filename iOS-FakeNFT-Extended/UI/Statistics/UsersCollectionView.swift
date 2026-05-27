import SwiftUI

struct UsersCollectionView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @StateObject private var viewModel: UsersCollectionViewModel
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 9),
        count: 3
    )
    
    init(user: StatisticsUser) {
        _viewModel = StateObject(wrappedValue: UsersCollectionViewModel(user: user))
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.whiteYP))
            .navigationTitle("Коллекция NFT")
            .navigationBarTitleDisplayMode(.inline)
            .tint(Color(.blackYP))
            .task {
                await viewModel.loadNfts(service: servicesAssembly.collectionService)
            }
            .alert(
                "Ошибка",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in viewModel.errorMessage = nil }
                )
            ) {
                Button("ОК", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
    }
}

// MARK: - Subviews

private extension UsersCollectionView {
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
            
        case .loaded:
            if viewModel.nfts.isEmpty {
                emptyView
            } else {
                collectionGrid
            }
            
        case .failed:
            errorView
        }
    }
    
    var loadingView: some View {
        ProgressView()
            .tint(.blackYP)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var collectionGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 28) {
                ForEach(viewModel.nfts) { nft in
                    NftCellView(
                        nftCartToggled: { nftId, isInCart in
                            Task {
                                await viewModel.updateOrderCart(
                                    nftId: nftId,
                                    isInCart: isInCart
                                )
                            }
                        },
                        nftLikeToggled: { nftId, isLiked in
                            Task {
                                await viewModel.updateProfileLike(
                                    nftId: nftId,
                                    isLiked: isLiked
                                )
                            }
                        },
                        nft: nft
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .background(Color(.whiteYP))
    }
    
    var emptyView: some View {
        Text("Коллекция NFT пустая")
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(Color(.blackYP))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.whiteYP))
    }
    
    var errorView: some View {
        VStack(spacing: 16) {
            Text("Не удалось загрузить коллекцию")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(.blackYP))

            Button {
                Task {
                    await viewModel.reloadNfts(service: servicesAssembly.collectionService)
                }
            } label: {
                Text("Повторить")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.whiteUniversalYP)
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color(.blackYP))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(.horizontal, 16)
        .background(Color(.whiteYP))
    }
}
