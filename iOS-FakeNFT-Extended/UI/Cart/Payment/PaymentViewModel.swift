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
    
    private(set) var state: PaymentState = .initial
    private(set) var selectedCurrency: Currency?
    private(set) var errorMessage: String?
    
    // MARK: - Computed properties
    
    var isPayButtonEnabled: Bool {
        selectedCurrency != nil
    }
    
    // MARK: - Init
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
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
        errorMessage = makeErrorMessage(from: error)
    }
    
    private func makeErrorMessage(from error: Error) -> String {
        guard let networkError = error as? NetworkClientError else {
            return Constants.defaultErrorMessage
        }
        
        switch networkError {
        case .httpStatusCode:
            return Constants.serverErrorMessage
            
        case .urlRequestError, .urlSessionError:
            return Constants.connectionErrorMessage
            
        case .parsingError:
            return Constants.parsingErrorMessage
            
        case .incorrectRequest:
            return Constants.requestErrorMessage
        }
    }
}

// MARK: - Constants

private extension PaymentViewModel {
    enum Constants {
        static let defaultErrorMessage = "Не удалось загрузить данные"
        static let serverErrorMessage = "Ошибка сервера. Попробуйте позже"
        static let connectionErrorMessage = "Проверьте подключение к интернету"
        static let parsingErrorMessage = "Не удалось обработать данные"
        static let requestErrorMessage = "Не удалось выполнить запрос"
    }
}
