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
    
    /// Проверяет, что ошибка загрузки валют переводит состояние в failed и задаёт errorMessage.
    func testLoadCurrenciesWhenServiceFailsSetsFailedStateAndErrorMessage() async {
        // Given
        let error = TestError.someError
        let viewModel = makeViewModelWithError(error)
        
        // When
        await viewModel.loadCurrencies()
        
        // Then
        guard case .failed = viewModel.state else {
            XCTFail("Expected failed state")
            return
        }
        
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    /// Проверяет, что выбор валюты сохраняет её и включает кнопку оплаты.
    func testSelectCurrencyStoresSelectedCurrencyAndEnablesPayButton() {
        // Given
        let currency = Currency.shibaInu
        let viewModel = makeViewModel(currencies: [currency])
        
        // When
        viewModel.selectCurrency(currency)
        
        // Then
        XCTAssertEqual(viewModel.selectedCurrency?.id, currency.id)
        XCTAssertTrue(viewModel.isPayButtonEnabled)
    }
    
    /// Проверяет, что isSelected отличает выбранную валюту от невыбранной.
    func testIsSelectedWhenCurrencyWasSelectedReturnsCorrectSelectionState() {
        // Given
        let currency1 = Currency.shibaInu
        let currency2 = Currency.dogecoin
        let viewModel = makeViewModel(
            currencies: [currency1, currency2]
        )
        
        viewModel.selectCurrency(currency1)
        
        // When
        let isSelectedCurrency1 = viewModel.isSelected(currency1)
        let isSelectedCurrency2 = viewModel.isSelected(currency2)
        
        // Then
        XCTAssertTrue(isSelectedCurrency1)
        XCTAssertFalse(isSelectedCurrency2)
    }
    
    /// Проверяет, что кнопка оплаты выключена без выбранной валюты.
    func testIsPayButtonEnabledWhenCurrencyIsNotSelectedReturnsFalse() {
        // Given
        let viewModel = makeViewModel(currencies: [])
        
        // When
        let isPayButtonEnabled = viewModel.isPayButtonEnabled
        
        // Then
        XCTAssertFalse(isPayButtonEnabled)
    }


    // MARK: - Private Methods (Helpers)
    
    private func makeViewModel(
        currencies: [Currency]
    ) -> PaymentViewModel {
        PaymentViewModel(
            currencyService: CurrencyServiceStub(currencies: currencies)
        )
    }
    
    private func makeViewModelWithError(_ error: Error) -> PaymentViewModel {
        PaymentViewModel(
            currencyService: CurrencyServiceStub(error: error)
        )
    }
}
