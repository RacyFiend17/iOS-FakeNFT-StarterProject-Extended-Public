//
//  CartViewModelTests.swift
//  iOS-FakeNFT-ExtendedTests
//
//  Created by Алла on 15.05.2026.
//

import XCTest
@testable import iOS_FakeNFT_Extended

@MainActor
final class CartViewModelTests: XCTestCase {
    /// Проверяет, что ViewModel переводит корзину в content после успешной загрузки нескольких NFT.
    func testLoadCartWhenOrderHasSeveralNftsSetsContentState() async {
        // Given
        let nft1 = Nft.mock1
        let nft2 = Nft.mock2
        let nft3 = Nft.mock3
        
        let order = Order(
            id: "order-1",
            nfts: [nft1.id, nft2.id, nft3.id]
        )
        
        let viewModel = makeViewModel(
            order: order,
            nftsById: [
                nft1.id: nft1,
                nft2.id: nft2,
                nft3.id: nft3
            ]
        )
        
        // When
        await viewModel.loadCart()
        
        // Then
        guard case .content(let nfts) = viewModel.state else {
            XCTFail("Expected content state")
            return
        }
        
        XCTAssertEqual(nfts.count, 3)
        XCTAssertEqual(nfts.map(\.id), [nft1.id, nft2.id, nft3.id])
        XCTAssertNil(viewModel.errorMessage)
    }
    
    /// Проверяет, что ViewModel переводит корзину в empty после успешной загрузки заказа без NFT.
    func testLoadCartWhenOrderHasNoNftsSetsEmptyState() async {
        // Given
        let order = Order(
            id: "empty-order",
            nfts: []
        )
        
        let viewModel = makeViewModel(
            order: order,
            nftsById: [:]
        )
        
        // When
        await viewModel.loadCart()
        
        // Then
        guard case .empty = viewModel.state else {
            XCTFail("Expected empty state")
            return
        }
        
        XCTAssertEqual(viewModel.totalCount, 0)
        XCTAssertEqual(viewModel.totalPrice, 0)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    /// Проверяет, что totalCount возвращает количество NFT из состояния content.
    func testTotalCountWhenStateIsContentReturnsNftsCount() {
        // Given
        let nfts = [Nft.mock1, Nft.mock2, Nft.mock3]
        let viewModel = makeViewModelWithState(.content(nfts))
        
        // When
        let totalCount = viewModel.totalCount
        
        // Then
        XCTAssertEqual(totalCount, 3)
    }
    
    /// Проверяет, что totalPrice возвращает сумму цен NFT из состояния content.
    func testTotalPriceWhenStateIsContentReturnsNftsTotalPrice() {
        // Given
        let nfts = [Nft.mock1, Nft.mock2, Nft.mock3]
        let viewModel = makeViewModelWithState(.content(nfts))
        
        // When
        let totalPrice = viewModel.totalPrice
        
        // Then
        XCTAssertEqual(totalPrice, 4.5, accuracy: 0.001)
    }
    
    /// Проверяет, что refreshCart обновляет content при изменении заказа.
    func testRefreshCartWhenOrderChangedUpdatesContentState() async {
        // Given
        let nft1 = Nft.mock1
        let nft2 = Nft.mock2
        let nft3 = Nft.mock3
        
        let firstOrder = Order(
            id: "first-order",
            nfts: [nft1.id]
        )
        
        let refreshedOrder = Order(
            id: "refreshed-order",
            nfts: [nft2.id, nft3.id]
        )
        
        let orderService = SequentialOrderServiceStub(
            orders: [firstOrder, refreshedOrder]
        )
        
        let nftService = NftServiceStub(
            nftsById: [
                nft1.id: nft1,
                nft2.id: nft2,
                nft3.id: nft3
            ]
        )
        
        let viewModel = makeViewModelWithServices(
            orderService: orderService,
            nftService: nftService
        )
        
        // When
        await viewModel.loadCart()
        
        // Then
        guard case .content(let initialNfts) = viewModel.state else {
            XCTFail("Expected initial content state")
            return
        }
        
        XCTAssertEqual(initialNfts.map(\.id), [nft1.id])
        XCTAssertNil(viewModel.errorMessage)
        
        // When
        await viewModel.refreshCart()
        
        // Then
        guard case .content(let refreshedNfts) = viewModel.state else {
            XCTFail("Expected refreshed content state")
            return
        }
        
        XCTAssertEqual(refreshedNfts.map(\.id), [nft2.id, nft3.id])
        XCTAssertNil(viewModel.errorMessage)
    }
    
    /// Проверяет, что ошибка загрузки заказа переводит корзину в empty и задаёт errorMessage.
    func testLoadCartWhenOrderServiceFailsSetsEmptyStateAndErrorMessage() async {
        // Given
        let orderService = OrderServiceStub(error: TestError.someError)
        let nftService = NftServiceStub(nftsById: [:])
        
        let viewModel = makeViewModelWithServices(
            orderService: orderService,
            nftService: nftService,
            state: .initial
        )
        
        // When
        await viewModel.loadCart()
        
        // Then
        guard case .empty = viewModel.state else {
            XCTFail("Expected empty state")
            return
        }
        
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    /// Проверяет, что ошибка загрузки NFT по id переводит корзину в empty и задаёт errorMessage.
    func testLoadCartWhenNftServiceFailsSetsEmptyStateAndErrorMessage() async {
        // Given
        let missingNftId = "missing-nft-id"
        let order = Order(
            id: "order-1",
            nfts: [missingNftId]
        )
        
        let viewModel = makeViewModel(
            order: order,
            nftsById: [:]
        )
        
        // When
        await viewModel.loadCart()
        
        // Then
        guard case .empty = viewModel.state else {
            XCTFail("Expected empty state")
            return
        }
        
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    // MARK: - Private Methods (Helpers)
    
    private func makeViewModel(
        order: Order,
        nftsById: [String: Nft],
        state: CartState = .initial
    ) -> CartViewModel {
        let orderService = OrderServiceStub(order: order)
        let nftService = NftServiceStub(nftsById: nftsById)
        
        return CartViewModel(
            orderService: orderService,
            nftService: nftService,
            state: state
        )
    }
    
    private func makeViewModelWithState(_ state: CartState) -> CartViewModel {
        makeViewModel(
            order: Order(id: "unused-order", nfts: []),
            nftsById: [:],
            state: state
        )
    }
    
    private func makeViewModelWithServices(
        orderService: OrderService,
        nftService: NftService,
        state: CartState = .initial
    ) -> CartViewModel {
        CartViewModel(
            orderService: orderService,
            nftService: nftService,
            state: state
        )
    }
}
