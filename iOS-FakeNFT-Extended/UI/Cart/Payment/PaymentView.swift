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
    
    init(
        viewModel: PaymentViewModel,
        shouldLoadOnAppear: Bool = true,
        onAgreementTap: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: viewModel)
        self.shouldLoadOnAppear = shouldLoadOnAppear
        self.onAgreementTap = onAgreementTap
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.whiteYP)
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
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
                    await viewModel.loadCurrencies()
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
                    // TODO: реализовать оплату
                }
            )
        }
    }
}

// MARK: - Constants

private extension PaymentView {
    enum Constants {
        static let cancelButtonTitle = "Отмена"
        static let retryButtonTitle = "Повторить"
        static let navigationTitle = "Выберите способ оплаты"
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PaymentView(
            viewModel: PaymentViewModel(
                currencyService: PaymentPreviewService()
            )
        )
    }
}

// MARK: - Preview Mocks

private struct PaymentPreviewService: CurrencyService {
    func loadCurrencies() async throws -> [Currency] {
        Currency.mocks
    }
}
