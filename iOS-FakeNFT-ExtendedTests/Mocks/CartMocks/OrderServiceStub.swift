//
//  OrderServiceStub.swift
//  iOS-FakeNFT-ExtendedTests
//
//  Created by Алла on 15.05.2026.
//

@testable import iOS_FakeNFT_Extended

final class OrderServiceStub: OrderService {
    private let result: Result<Order, Error>
    private let paymentResult: Result<PaymentResult, Error>
    private(set) var paidCurrencyId: String?
    private(set) var completedNftIds: [String]?
    
    init(
        order: Order,
        paymentResult: PaymentResult = PaymentResult(
            success: true,
            orderId: "test-order",
            id: "test-payment"
        )
    ) {
        self.result = .success(order)
        self.paymentResult = .success(paymentResult)
    }
    
    init(
        order: Order,
        paymentError: Error
    ) {
        self.result = .success(order)
        self.paymentResult = .failure(paymentError)
    }
    
    init(error: Error) {
        self.result = .failure(error)
        self.paymentResult = .failure(error)
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
        paidCurrencyId = currencyId
        return try paymentResult.get()
    }
    
    func completeOrder(nftIds: [String]) async throws -> Order {
        completedNftIds = nftIds
        
        return Order(
            id: "completed-order",
            nfts: nftIds
        )
    }
}
