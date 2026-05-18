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

// MARK: - Cart Sort Options

enum CartSortOption: String {
    case price
    case rating
    case name
}

// MARK: - CartViewModel

@MainActor
@Observable
final class CartViewModel {
    // MARK: - Private properties

    private let orderService: OrderService
    private let nftService: NftService
    private let userDefaults: UserDefaults

    private(set) var state: CartState = .initial
    private(set) var errorMessage: String?
    private(set) var isRefreshing = false
    private(set) var selectedSortOption: CartSortOption = .name

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
        userDefaults: UserDefaults = .standard,
        state: CartState = .initial
    ) {
        self.orderService = orderService
        self.nftService = nftService
        self.userDefaults = userDefaults
        self.state = state
        self.selectedSortOption = storedSortOption
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
        storedSortOption = option

        if case .content(let nfts) = state {
            state = .content(sortedNfts(nfts))
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

    private var storedSortOption: CartSortOption {
        get {
            guard let rawValue = userDefaults.string(
                forKey: Constants.selectedSortOptionKey
            ) else {
                return .name
            }

            return CartSortOption(rawValue: rawValue) ?? .name
        }

        set {
            userDefaults.set(
                newValue.rawValue,
                forKey: Constants.selectedSortOptionKey
            )
        }
    }

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

    // MARK: - Constants

    private enum Constants {
        static let selectedSortOptionKey = "cartSelectedSortOption"
    }
}
