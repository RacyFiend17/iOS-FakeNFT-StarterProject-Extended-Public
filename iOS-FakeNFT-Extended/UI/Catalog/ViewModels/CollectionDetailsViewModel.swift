//
//  CollectionDetailsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 18.05.2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class CollectionDetailsViewModel {
    
    var state: CollectionDetailsState = .loading
    
    var nfts: [Nft] = []
    var errorMessage: String?
    
    private let collection: Collection
    private let service: CollectionServiceProtocol
    private let favoritesSyncService: FavoritesSyncService
    private let cartSyncService: CartSyncService
    
    init(
        collection: Collection,
        service: CollectionServiceProtocol,
        profileService: ProfileService? = nil,
        orderService: OrderService? = nil
    ) {
        self.collection = collection
        self.service = service
        let profileService = profileService ?? ProfileServiceImpl(
            networkClient: DefaultNetworkClient()
        )
        self.favoritesSyncService = ProfileFavoritesSyncService(
            profileService: profileService
        )
        let orderService = orderService ?? OrderServiceImpl(
            networkClient: DefaultNetworkClient()
        )
        self.cartSyncService = OrderCartSyncService(
            orderService: orderService
        )
    }
    
    func load() async {
        
        state = .loading
        
        do {
            nfts = try await service.loadNfts(ids: collection.nfts)
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func updateProfileLike(nftId: String, isLiked: Bool) async {
        errorMessage = nil
        
        do {
            try await favoritesSyncService.updateProfileLike(
                nftId: nftId,
                isLiked: isLiked
            )
        } catch {
            errorMessage = "Не удалось обновить избранное"
        }
    }
    
    func updateOrderCart(nftId: String, isInCart: Bool) async {
        errorMessage = nil
        
        do {
            try await cartSyncService.updateOrderCart(
                nftId: nftId,
                isInCart: isInCart
            )
        } catch {
            errorMessage = "Не удалось обновить корзину"
        }
    }
}
