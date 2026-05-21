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
    private(set) var paymentResult: PaymentResult?
    private(set) var isPaying = false
    
    // MARK: - Computed properties
    
    var isPayButtonEnabled: Bool {
        selectedCurrency != nil
    }
    
    var isPaymentSuccessful: Bool {
        paymentResult != nil
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
    
    func payOrder() async {
        errorMessage = nil
        
        guard let selectedCurrency else {
            return
        }
        
        isPaying = true
        
        defer {
            isPaying = false
        }
        
        do {
            let order = try await orderService.loadOrder()
            let result = try await orderService.payOrder(
                currencyId: selectedCurrency.id
            )
            
            _ = try await orderService.completeOrder(nftIds: order.nfts)
            
            paymentResult = result
        } catch {
            handleLoadingError(error)
        }
    }
    
    // MARK: - Error handling
    
    private func handleLoadingError(_ error: Error) {
        errorMessage = ErrorMessageFactory.message(from: error)
    }
}
