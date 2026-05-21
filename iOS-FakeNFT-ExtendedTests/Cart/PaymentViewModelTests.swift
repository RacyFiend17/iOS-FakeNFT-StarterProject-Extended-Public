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
    
    /// Проверяет, что isSelected отличает выбранную валюту от не выбранной.
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
    
    /// Проверяет, что повторная успешная загрузка валют очищает старое errorMessage.
    func testLoadCurrenciesWhenRetrySucceedsClearsPreviousErrorMessage() async {
        // Given
        let currencies = [Currency.bitcoin]
        let currencyService = SequentialCurrencyServiceStub(
            results: [
                .failure(TestError.someError),
                .success(currencies)
            ]
        )
        
        let viewModel = PaymentViewModel(
            currencyService: currencyService,
            orderService: OrderServiceStub(
                order: Order(
                    id: "test-order",
                    nfts: []
                )
            )
        )
        
        // When
        await viewModel.loadCurrencies()
        
        // Then
        guard case .failed = viewModel.state else {
            XCTFail("Expected failed state")
            return
        }
        
        XCTAssertNotNil(viewModel.errorMessage)
        
        // When
        await viewModel.loadCurrencies()
        
        // Then
        guard case .content(let loadedCurrencies) = viewModel.state else {
            XCTFail("Expected content state")
            return
        }
        
        XCTAssertEqual(loadedCurrencies.map(\.id), currencies.map(\.id))
        XCTAssertNil(viewModel.errorMessage)
    }
    
    /// Проверяет, что оплата без выбранной валюты не вызывает сервис оплаты.
    func testPayOrderWhenCurrencyIsNotSelectedDoesNotCallOrderService() async {
        // Given
        let orderService = OrderServiceStub(
            order: Order(
                id: "test-order",
                nfts: []
            )
        )
        
        let viewModel = PaymentViewModel(
            currencyService: CurrencyServiceStub(currencies: []),
            orderService: orderService
        )
        
        // When
        await viewModel.payOrder()
        
        // Then
        XCTAssertNil(orderService.paidCurrencyId)
        XCTAssertNil(viewModel.paymentResult)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    /// Проверяет, что оплата выбранной валютой передаёт id валюты в сервис.
    func testPayOrderWhenCurrencyIsSelectedCallsOrderServiceWithCurrencyId() async {
        // Given
        let currency = Currency.bitcoin
        let orderService = OrderServiceStub(
            order: Order(
                id: "test-order",
                nfts: []
            )
        )
        
        let viewModel = PaymentViewModel(
            currencyService: CurrencyServiceStub(currencies: [currency]),
            orderService: orderService
        )
        
        viewModel.selectCurrency(currency)
        
        // When
        await viewModel.payOrder()
        
        // Then
        XCTAssertEqual(orderService.paidCurrencyId, currency.id)
    }
    
    /// Проверяет, что успешная оплата сохраняет результат оплаты.
    func testPayOrderWhenRequestSucceedsStoresPaymentResult() async {
        // Given
        let currency = Currency.bitcoin
        let expectedPaymentResult = PaymentResult(
            success: true,
            orderId: "test-order",
            id: "test-payment"
        )
        
        let orderService = OrderServiceStub(
            order: Order(
                id: "test-order",
                nfts: []
            ),
            paymentResult: expectedPaymentResult
        )
        
        let viewModel = PaymentViewModel(
            currencyService: CurrencyServiceStub(currencies: [currency]),
            orderService: orderService
        )
        
        viewModel.selectCurrency(currency)
        
        // When
        await viewModel.payOrder()
        
        // Then
        XCTAssertEqual(viewModel.paymentResult?.success, expectedPaymentResult.success)
        XCTAssertEqual(viewModel.paymentResult?.orderId, expectedPaymentResult.orderId)
        XCTAssertEqual(viewModel.paymentResult?.id, expectedPaymentResult.id)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isPaying)
    }
    
    /// Проверяет, что ошибка оплаты задаёт errorMessage и не сохраняет результат оплаты.
    func testPayOrderWhenRequestFailsSetsErrorMessage() async {
        // Given
        let currency = Currency.bitcoin
        let orderService = OrderServiceStub(
            order: Order(
                id: "test-order",
                nfts: [Nft.mock1.id]
            ),
            paymentError: TestError.someError
        )
        
        let viewModel = PaymentViewModel(
            currencyService: CurrencyServiceStub(currencies: [currency]),
            orderService: orderService
        )
        
        viewModel.selectCurrency(currency)
        
        // When
        await viewModel.payOrder()
        
        // Then
        XCTAssertEqual(orderService.paidCurrencyId, currency.id)
        XCTAssertNil(viewModel.paymentResult)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isPaying)
    }
    
    // MARK: - Private Methods (Helpers)
    
    private func makeViewModel(
        currencies: [Currency]
    ) -> PaymentViewModel {
        PaymentViewModel(
            currencyService: CurrencyServiceStub(currencies: currencies),
            orderService: OrderServiceStub(
                order: Order(
                    id: "test-order",
                    nfts: []
                )
            )
        )
    }
    
    private func makeViewModelWithError(_ error: Error) -> PaymentViewModel {
        PaymentViewModel(
            currencyService: CurrencyServiceStub(error: error),
            orderService: OrderServiceStub(
                order: Order(
                    id: "test-order",
                    nfts: []
                )
            )
        )
    }
}
