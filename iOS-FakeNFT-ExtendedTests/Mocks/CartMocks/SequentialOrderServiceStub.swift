//
//  SequentialOrderServiceStub.swift
//  iOS-FakeNFT-ExtendedTests
//
//  Created by Алла on 15.05.2026.
//

@testable import iOS_FakeNFT_Extended

final class SequentialOrderServiceStub: OrderService {
    enum StubError: Error {
        case noMoreOrders
    }
    
    private var orders: [Order]
    private var paymentResults: [Result<PaymentResult, Error>]
    
    private(set) var updatedNftIds: [String]?
    
    init(
        orders: [Order],
        paymentResults: [Result<PaymentResult, Error>] = [
            .success(
                PaymentResult(
                    success: true,
                    orderId: "test-order",
                    id: "test-payment"
                )
            )
        ]
    ) {
        self.orders = orders
        self.paymentResults = paymentResults
    }
    
    func loadOrder() async throws -> Order {
        guard !orders.isEmpty else {
            throw StubError.noMoreOrders
        }
        
        return orders.removeFirst()
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        updatedNftIds = nftIds
        
        return Order(
            id: "updated-order",
            nfts: nftIds
        )
    }
    
    func payOrder(currencyId: String) async throws -> PaymentResult {
        guard !paymentResults.isEmpty else {
            throw StubError.noMoreOrders
        }
        
        return try paymentResults.removeFirst().get()
    }
    
    func completeOrder(nftIds: [String]) async throws -> Order {
        Order(id: "completed-order", nfts: nftIds)
    }
}
