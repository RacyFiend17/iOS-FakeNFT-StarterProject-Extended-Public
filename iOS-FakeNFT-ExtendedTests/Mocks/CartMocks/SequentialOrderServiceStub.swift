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
    private(set) var updatedNftIds: [String]?
    
    init(orders: [Order]) {
        self.orders = orders
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
}
