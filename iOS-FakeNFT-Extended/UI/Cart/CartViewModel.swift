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
}

// MARK: - CartViewModel

@MainActor
@Observable
final class CartViewModel {
    // MARK: - Private properties
    
    private let orderService: OrderService
    private let nftService: NftService
    
    private(set) var state: CartState = .initial
    private(set) var errorMessage: String?
    private(set) var isRefreshing = false
    
    // MARK: - Computed properties
    
    var totalCount: Int {
        switch state {
        case .content(let nfts): nfts.count
        default: 0
        }
    }
    
    var totalPrice: Double {
        switch state {
        case .content(let nfts): nfts.reduce(0) { $0 + $1.price }
        default: 0
        }
    }
    
    // MARK: - Init
    
    init(orderService: OrderService, nftService: NftService, state: CartState = .initial) {
        self.orderService = orderService
        self.nftService = nftService
        self.state = state
    }
    
    // MARK: - Public Methods
    
    func loadCart() async {
        await loadCart(shouldShowRefreshOverlay: true)
    }
    
    func refreshCart() async {
        await loadCart(shouldShowRefreshOverlay: false)
    }
    
    // MARK: - Private Methods
    
    private func loadCart(shouldShowRefreshOverlay: Bool) async {
        errorMessage = nil
        
        switch state {
        case .content:
            isRefreshing = shouldShowRefreshOverlay
        case .initial, .loading, .empty:
            state = .loading
        }
        
        defer {
            isRefreshing = false
        }
        
        do {
            let nfts = try await loadCartNfts()
            state = nfts.isEmpty ? .empty : .content(nfts)
        } catch {
            handleLoadingError(error)
        }
    }
    
    private func loadCartNfts() async throws -> [Nft] {
        let order = try await orderService.loadOrder()
        var nfts: [Nft] = []
        
        for id in order.nfts {
            let nft = try await nftService.loadNft(id: id)
            nfts.append(nft)
        }
        
        return nfts
    }
    
    // MARK: - Error handling
    
    private func handleLoadingError(_ error: Error) {
        errorMessage = ErrorMessageFactory.message(from: error)
        
        if case .loading = state {
            state = .empty
        }
    }
}
