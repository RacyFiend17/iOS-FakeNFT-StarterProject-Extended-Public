//
//  PaymentViewModelTests.swift
//  iOS-FakeNFT-ExtendedTests
//
//  Created by Алла on 16.05.2026.
//

import XCTest
@testable import iOS_FakeNFT_Extended

@MainActor
final class PaymentViewModelTests: XCTestCase {
    
    /// Проверяет, что успешная загрузка валют переводит состояние в content.
    func testLoadCurrenciesWhenServiceSucceedsSetsContentState() async {
        // Given
        let currencies = [
            Currency.shibaInu,
            Currency.cardano
        ]
        
        let viewModel = makeViewModel(currencies: currencies)
        
        // When
        await viewModel.loadCurrencies()
        
        // Then
        guard case .content(let loadedCurrencies) = viewModel.state else {
            XCTFail("Expected content state")
            return
        }
        
        XCTAssertEqual(loadedCurrencies.count, 2)
        XCTAssertEqual(loadedCurrencies.map(\.id), currencies.map(\.id))
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Private Methods (Helpers)
    
    private func makeViewModel(
        currencies: [Currency]
    ) -> PaymentViewModel {
        PaymentViewModel(
            currencyService: CurrencyServiceStub(currencies: currencies)
        )
    }
}
