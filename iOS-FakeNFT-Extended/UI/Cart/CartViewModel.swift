//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 04.05.2026.
//

import Foundation

@MainActor
@Observable
final class CartViewModel {
    private let orderService: OrderService
    private let nftService: NftService
    
    init(orderService: OrderService, nftService: NftService) {
        self.orderService = orderService
        self.nftService = nftService
    }
    
    func loadCartNfts() async throws -> [Nft] {
        let order = try await orderService.loadOrder()
        var nfts: [Nft] = []
        
        for id in order.nfts {
            let nft = try await nftService.loadNft(id: id)
            nfts.append(nft)
        }
        
        return nfts
    }
}

