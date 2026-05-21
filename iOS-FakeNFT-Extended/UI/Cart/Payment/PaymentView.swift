//
//  PaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 12.05.2026.
//

import SwiftUI

struct PaymentView: View {
    @State private var viewModel: PaymentViewModel
    @State private var isErrorAlertPresented = false
    
    private let shouldLoadOnAppear: Bool
    private let onAgreementTap: () -> Void
    private let onPaymentSuccess: () -> Void
    
    init(
        viewModel: PaymentViewModel,
        shouldLoadOnAppear: Bool = true,
        onAgreementTap: @escaping () -> Void = {},
        onPaymentSuccess: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: viewModel)
        self.shouldLoadOnAppear = shouldLoadOnAppear
        self.onAgreementTap = onAgreementTap
        self.onPaymentSuccess = onPaymentSuccess
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            content
            
            LoadingOverlayView()
                .opacity(viewModel.isPaying ? 1 : 0)
                .accessibilityHidden(!viewModel.isPaying)
                .allowsHitTesting(viewModel.isPaying)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.whiteYP)
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.errorMessage) { _, newValue in
            isErrorAlertPresented = newValue != nil
        }
        .onChange(of: viewModel.isPaymentSuccessful) { _, isSuccessful in
            if isSuccessful {
                onPaymentSuccess()
            }
        }
        .alert(
            alertTitle,
            isPresented: $isErrorAlertPresented
        ) {
            Button(Constants.cancelButtonTitle, role: .cancel) { }
            Button(Constants.retryButtonTitle) {
                Task {
                    if viewModel.didStartPayment {
                        await viewModel.payOrder()
                    } else {
                        await viewModel.loadCurrencies()
                    }
                }
            }
        }
        .task {
            guard shouldLoadOnAppear else { return }
            
            await viewModel.loadCurrencies()
        }
    }
}

// MARK: - Content

private extension PaymentView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .initial, .loading:
            ProgressView()
                .tint(.blackYP)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .content(let currencies):
            paymentContent(currencies)
            
        case .failed:
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // MARK: - Subviews
    
    func paymentContent(_ currencies: [Currency]) -> some View {
        VStack(spacing: 0) {
            PaymentCurrencyList(
                currencies: currencies,
                isSelected: viewModel.isSelected,
                onSelect: viewModel.selectCurrency
            )
            
            PaymentSummaryView(
                isPayButtonEnabled: viewModel.isPayButtonEnabled,
                onAgreementTap: onAgreementTap,
                onPayTap: {
                    Task {
                        await viewModel.payOrder()
                    }
                }
            )
        }
    }
    
    var alertTitle: String {
        if viewModel.didStartPayment {
            return Constants.paymentErrorTitle
        }
        
        return viewModel.errorMessage ?? ""
    }
}

// MARK: - Constants

private extension PaymentView {
    enum Constants {
        static let cancelButtonTitle = "Отмена"
        static let retryButtonTitle = "Повторить"
        static let navigationTitle = "Выберите способ оплаты"
        static let paymentErrorTitle = "Не удалось произвести\nоплату"
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        let service = PaymentPreviewService()
        
        PaymentView(
            viewModel: PaymentViewModel(
                currencyService: service,
                orderService: service
            )
        )
    }
}

// MARK: - Preview Mocks

private struct PaymentPreviewService: CurrencyService, OrderService {
    func loadCurrencies() async throws -> [Currency] {
        Currency.mocks
    }
    
    func loadOrder() async throws -> Order {
        Order(id: "preview-order", nfts: [])
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        Order(id: "preview-order", nfts: nftIds)
    }
    
    func payOrder(currencyId: String) async throws -> PaymentResult {
        PaymentResult(success: true, orderId: "preview-order", id: currencyId)
    }
    
    func completeOrder(nftIds: [String]) async throws -> Order {
        Order(id: "preview-order", nfts: nftIds)
    }
}
