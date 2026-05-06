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
    
    init(orderService: OrderService, nftService: NftService, state: CartState = .initial) {
        self.orderService = orderService
        self.nftService = nftService
        self.state = state
    }
    
    // MARK: - Public Methods
    
    func loadCart() async {
        errorMessage = nil
        
        switch state {
        case .content:
            break
        case .initial, .loading, .empty:
            state = .loading
        }
        
        do {
            let nfts = try await loadCartNfts()
            state = nfts.isEmpty ? .empty : .content(nfts)
        } catch {
            handleLoadingError(error)
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
    
    // MARK: - Error handling
    
    private func handleLoadingError(_ error: Error) {
        errorMessage = makeErrorMessage(from: error)
        
        if case .loading = state {
            state = .empty
        }
    }
    
    private func makeErrorMessage(from error: Error) -> String {
        guard let networkError = error as? NetworkClientError else {
            return Constants.defaultErrorMessage
        }
        
        switch networkError {
        case .httpStatusCode:
            return Constants.serverErrorMessage
            
        case .urlRequestError, .urlSessionError:
            return Constants.connectionErrorMessage
            
        case .parsingError:
            return Constants.parsingErrorMessage
            
        case .incorrectRequest:
            return Constants.requestErrorMessage
        }
    }
}

// MARK: - Constants

private extension CartViewModel {
    enum Constants {
        static let defaultErrorMessage = "Не удалось загрузить данные"
        static let serverErrorMessage = "Ошибка сервера. Попробуйте позже"
        static let connectionErrorMessage = "Проверьте подключение к интернету"
        static let parsingErrorMessage = "Не удалось обработать данные"
        static let requestErrorMessage = "Не удалось выполнить запрос"
    }
}
