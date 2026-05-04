//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 04.05.2026.
//

import Foundation

// MARK: - Cart States

enum CartState {
    case initial
    case loading
    case empty
    case content([Nft])
    case failed
}

// MARK: - CartViewModel

@MainActor
@Observable
final class CartViewModel {
    // MARK: - Private properties
    
    private let orderService: OrderService
    private let nftService: NftService
    private(set) var state: CartState = .initial
    
    // MARK: - Computed properties
    
    var totalCount: Int {
        switch state {
        case .content(let nfts):
            return nfts.count
        default:
            return 0
        }
    }
    
    var totalPrice: Double {
        switch state {
        case .content(let nfts):
            return nfts.reduce(0) { $0 + $1.price }
        default:
            return 0
        }
    }
    
    // MARK: - Init
    
    init(orderService: OrderService, nftService: NftService) {
        self.orderService = orderService
        self.nftService = nftService
    }
    
    // MARK: - Public Methods
    
    func loadCart() async {
        state = .loading
        
        do {
            let nfts = try await loadCartNfts()
            state = nfts.isEmpty ? .empty : .content(nfts)
        } catch {
            state = .failed
        }
    }
    
    // MARK: - Private Methods
    
    private func loadCartNfts() async throws -> [Nft] {
        let order = try await orderService.loadOrder()
        var nfts: [Nft] = []
        
        for id in order.nfts {
            let nft = try await nftService.loadNft(id: id)
            nfts.append(nft)
        }
        
        return nfts
    }
}
