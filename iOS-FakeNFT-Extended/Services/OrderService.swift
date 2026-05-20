//
//  OrderService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 04.05.2026.
//

import Foundation

protocol OrderService {
    func loadOrder() async throws -> Order
    func updateOrder(nftIds: [String]) async throws -> Order
    func payOrder(currencyId: String) async throws -> PaymentResult
}

actor OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrder() async throws -> Order {
        let request = OrderRequest()
        let order: Order = try await networkClient.send(request: request)
        return order
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        let request = UpdateOrderRequest(nftIds: nftIds)
        let order: Order = try await networkClient.send(request: request)
        return order
    }
    
    func payOrder(currencyId: String) async throws -> PaymentResult {
        let request = PayOrderRequest(currencyId: currencyId)
        let paymentResult: PaymentResult = try await networkClient.send(request: request)
        return paymentResult
    }
}
