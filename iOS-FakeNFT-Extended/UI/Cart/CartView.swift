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
    
    private let onSortButtonTap: () -> Void
    private let shouldLoadOnAppear: Bool
    
    init(viewModel: CartViewModel,
         shouldLoadOnAppear: Bool = true,
         onSortButtonTap: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: viewModel)
        self.shouldLoadOnAppear = shouldLoadOnAppear
        self.onSortButtonTap = onSortButtonTap
    }
    
    // MARK: - Body
    
    var body: some View {
        content
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
                }
            )
            
            CartSummaryView(
                totalCount: viewModel.totalCount,
                totalPrice: viewModel.totalPrice,
                onPaymentTap: {
                    // TODO: реализовать логику перехода к оплате во 2 части эпика
                }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var sortButton: some View {
        Button(action: onSortButtonTap) {
            AppIcon.sort.image
                .foregroundStyle(.blackYP)
                .frame(width: 42, height: 42)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Constants

private extension CartView {
    enum Constants {
        static let emptyCartTitle = "Корзина пуста"
        static let cancelButtonTitle = "Отмена"
        static let retryButtonTitle = "Повторить"
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
