//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 05.05.2026.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel: CartViewModel
    @State private var isErrorAlertPresented = false
    @State private var isSortDialogPresented = false
    
    private let shouldLoadOnAppear: Bool
    private let onPaymentTap: () -> Void
    
    init(viewModel: CartViewModel,
         shouldLoadOnAppear: Bool = true,
         onPaymentTap: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: viewModel)
        self.shouldLoadOnAppear = shouldLoadOnAppear
        self.onPaymentTap = onPaymentTap
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            content
            
            loadingOverlay
                .opacity(viewModel.isRefreshing ? 1 : 0)
                .accessibilityHidden(!viewModel.isRefreshing)
                .allowsHitTesting(viewModel.isRefreshing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.whiteYP)
        .onChange(of: viewModel.errorMessage) { _, newValue in
            isErrorAlertPresented = newValue != nil
        }
        .alert(
            viewModel.errorMessage ?? "",
            isPresented: $isErrorAlertPresented
        ) {
            Button(Constants.cancelButtonTitle, role: .cancel) { }
            
            Button(Constants.retryButtonTitle) {
                Task {
                    await viewModel.loadCart()
                }
            }
        }
        .confirmationDialog(
            Constants.sortDialogTitle,
            isPresented: $isSortDialogPresented,
            titleVisibility: .visible,
            actions: {
                sortDialogActions
            }
        )
        .task {
            guard shouldLoadOnAppear else { return }
            
            await viewModel.loadCart()
        }
    }
}

// MARK: - Content

private extension CartView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .initial, .loading:
            ProgressView()
                .tint(.blackYP)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .empty:
            emptyView
            
        case .content(let nfts):
            cartContent(nfts)
        }
    }
    
    // MARK: - Subviews
    
    var emptyView: some View {
        Text(Constants.emptyCartTitle)
            .font(.bodyBold)
            .foregroundStyle(.blackYP)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func cartContent(_ nfts: [Nft]) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                sortButton
                    .padding(.trailing, 9)
            }
            .padding(.bottom, 20)
            
            CartNftList(
                nfts: nfts,
                onDeleteTap: { _ in
                    // TODO: реализовать логику удаления в 3 части эпика
                },
                onRefresh: {
                    await viewModel.refreshCart()
                }
            )
            
            CartSummaryView(
                totalCount: viewModel.totalCount,
                totalPrice: viewModel.totalPrice,
                onPaymentTap: onPaymentTap
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var sortButton: some View {
        Button {
            isSortDialogPresented = true
        } label: {
            AppIcon.sort.image
                .foregroundStyle(.blackYP)
                .frame(width: 42, height: 42)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var sortDialogActions: some View {
        Button(Constants.sortByPriceTitle) {
            viewModel.selectSortOption(.price)
        }
        
        Button(Constants.sortByRatingTitle) {
            viewModel.selectSortOption(.rating)
        }
        
        Button(Constants.sortByNameTitle) {
            viewModel.selectSortOption(.name)
        }
        
        Button(Constants.closeButtonTitle, role: .cancel) { }
    }
    
    var loadingOverlay: some View {
        ProgressView()
            .tint(.blackYP)
            .frame(width: 82, height: 82)
            .background(.grayLightYP)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Constants

private extension CartView {
    enum Constants {
        static let emptyCartTitle = "Корзина пуста"
        static let cancelButtonTitle = "Отмена"
        static let retryButtonTitle = "Повторить"
        
        static let sortDialogTitle = "Сортировка"
        static let sortByPriceTitle = "По цене"
        static let sortByRatingTitle = "По рейтингу"
        static let sortByNameTitle = "По названию"
        static let closeButtonTitle = "Закрыть"
    }
}

// MARK: - Preview

#Preview("Content") {
    CartView(
        viewModel: .preview(
            state: .content([.mock1, .mock2, .mock3])
        ),
        shouldLoadOnAppear: false
    )
}

#Preview("Empty") {
    CartView(
        viewModel: .preview(state: .empty),
        shouldLoadOnAppear: false
    )
}

// MARK: - Preview Mocks

private struct CartPreviewService: OrderService, NftService {
    func loadOrder() async throws -> Order {
        Order(id: "preview-order", nfts: [])
    }
    
    func loadNft(id: String) async throws -> Nft {
        .mock1
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        Order(id: "preview-order", nfts: nftIds)
    }
}

extension CartViewModel {
    static func preview(state: CartState) -> CartViewModel {
        let service = CartPreviewService()
        
        return CartViewModel(
            orderService: service,
            nftService: service,
            state: state
        )
    }
}
