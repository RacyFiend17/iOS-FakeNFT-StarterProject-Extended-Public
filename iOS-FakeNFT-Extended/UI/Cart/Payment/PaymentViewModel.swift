//
//  PaymentViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 12.05.2026.
//

import Foundation

// MARK: - Payment States

enum PaymentState {
    case initial
    case loading
    case content([Currency])
    case failed
}

// MARK: - PaymentViewModel

@MainActor
@Observable
final class PaymentViewModel {
    // MARK: - Private properties
    
    private let currencyService: CurrencyService
    private let orderService: OrderService
    
    private(set) var state: PaymentState = .initial
    private(set) var selectedCurrency: Currency?
    private(set) var errorMessage: String?
    
    // MARK: - Computed properties
    
    var isPayButtonEnabled: Bool {
        selectedCurrency != nil
    }
    
    // MARK: - Init
    
    init(
        currencyService: CurrencyService,
        orderService: OrderService
    ) {
        self.currencyService = currencyService
        self.orderService = orderService
    }
    
    // MARK: - Public Methods
    
    func loadCurrencies() async {
        errorMessage = nil
        state = .loading
        
        do {
            let currencies = try await currencyService.loadCurrencies()
            state = .content(currencies)
        } catch {
            handleLoadingError(error)
            state = .failed
        }
    }
    
    func selectCurrency(_ currency: Currency) {
        selectedCurrency = currency
    }
    
    func isSelected(_ currency: Currency) -> Bool {
        selectedCurrency?.id == currency.id
    }
    
    // MARK: - Error handling
    
    private func handleLoadingError(_ error: Error) {
        errorMessage = ErrorMessageFactory.message(from: error)
    }
}
