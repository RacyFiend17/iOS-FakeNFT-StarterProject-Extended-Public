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
    private let sortStorage: CartSortStorage
    private let cartNftStorage: CartNftStorage?
    
    private(set) var state: CartState = .initial
    private(set) var errorMessage: String?
    private(set) var isRefreshing = false
    private(set) var selectedSortOption: CartSortOption = .name
    private(set) var selectedNftToDelete: Nft?

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

    init(
        orderService: OrderService,
        nftService: NftService,
        sortStorage: CartSortStorage = UserDefaultsCartSortStorage(),
        cartNftStorage: CartNftStorage? = nil,
        state: CartState = .initial
    ) {
        self.orderService = orderService
        self.nftService = nftService
        self.sortStorage = sortStorage
        self.cartNftStorage = cartNftStorage
        self.state = state
        self.selectedSortOption = sortStorage.selectedSortOption
    }

    // MARK: - Public Methods
    
    func loadCart() async {
        await loadCart(shouldShowRefreshOverlay: true)
    }
    
    func refreshCart() async {
        await loadCart(shouldShowRefreshOverlay: false)
    }
    
    func selectSortOption(_ option: CartSortOption) {
        selectedSortOption = option
        sortStorage.selectedSortOption = option
        
        if case .content(let nfts) = state {
            state = .content(sortedNfts(nfts))
        }
    }
    
    func selectNftToDelete(_ nft: Nft) {
        selectedNftToDelete = nft
    }
    
    func cancelNftDeletion() {
        selectedNftToDelete = nil
    }
    
    func deleteSelectedNft() async {
        errorMessage = nil
        
        guard let nftToDelete = selectedNftToDelete else {
            return
        }
        
        guard case .content(let nfts) = state else {
            return
        }
        
        let updatedNfts = nfts.filter { $0.id != nftToDelete.id }
        let updatedNftIds = updatedNfts.map(\.id)
        
        do {
            _ = try await orderService.updateOrder(nftIds: updatedNftIds)
            cartNftStorage?.remove(id: nftToDelete.id)
            selectedNftToDelete = nil
            state = updatedNfts.isEmpty ? .empty : .content(sortedNfts(updatedNfts))
        } catch {
            errorMessage = ErrorMessageFactory.message(from: error)
        }
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
            let sortedCartNfts = sortedNfts(nfts)
            state = sortedCartNfts.isEmpty ? .empty : .content(sortedCartNfts)
        } catch {
            handleLoadingError(error)
        }
    }
    
    private func loadCartNfts() async throws -> [Nft] {
        let order = try await orderService.loadOrder()
        cartNftStorage?.replace(with: order.nfts)
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
    
    // MARK: - Sorting
    
    private func sortedNfts(_ nfts: [Nft]) -> [Nft] {
        switch selectedSortOption {
        case .price:
            nfts.sorted { $0.price < $1.price }
            
        case .rating:
            nfts.sorted { $0.rating > $1.rating }
            
        case .name:
            nfts.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
}
