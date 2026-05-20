//
//  OrderServiceStub.swift
//  iOS-FakeNFT-ExtendedTests
//
//  Created by Алла on 15.05.2026.
//

@testable import iOS_FakeNFT_Extended

final class OrderServiceStub: OrderService {
    private let result: Result<Order, Error>
    
    init(order: Order) {
        self.result = .success(order)
    }
    
    init(error: Error) {
        self.result = .failure(error)
    }
    
    func loadOrder() async throws -> Order {
        try result.get()
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        let currentOrder = try result.get()
        
        return Order(
            id: currentOrder.id,
            nfts: nftIds
        )
    }
    
    func payOrder(currencyId: String) async throws -> PaymentResult {
        PaymentResult(
            success: true,
            orderId: "test-order",
            id: currencyId
        )
    }
}
