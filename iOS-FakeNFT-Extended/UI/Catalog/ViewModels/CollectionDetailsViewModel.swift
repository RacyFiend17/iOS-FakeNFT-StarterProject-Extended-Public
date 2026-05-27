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
    private let profileService: ProfileService
    private let orderService: OrderService
    
    init(
        collection: Collection,
        service: CollectionServiceProtocol,
        profileService: ProfileService? = nil,
        orderService: OrderService? = nil
    ) {
        self.collection = collection
        self.service = service
        self.profileService = profileService ?? ProfileServiceImpl(
            networkClient: DefaultNetworkClient()
        )
        self.orderService = orderService ?? OrderServiceImpl(
            networkClient: DefaultNetworkClient()
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
            let profile = try await profileService.loadProfile()
            var likes = profile.likes
            
            if isLiked {
                if !likes.contains(nftId) {
                    likes.append(nftId)
                }
            } else {
                likes.removeAll { $0 == nftId }
            }
            
            let updatedProfile = Profile(
                id: profile.id,
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nfts: profile.nfts,
                likes: likes
            )
            
            _ = try await profileService.updateProfile(updatedProfile)
        } catch {
            errorMessage = "Не удалось обновить избранное"
        }
    }
    
    func updateOrderCart(nftId: String, isInCart: Bool) async {
        errorMessage = nil
        
        do {
            let order = try await orderService.loadOrder()
            var nftIds = order.nfts
            
            if isInCart {
                if !nftIds.contains(nftId) {
                    nftIds.append(nftId)
                }
            } else {
                nftIds.removeAll { $0 == nftId }
            }
            
            _ = try await orderService.updateOrder(nftIds: nftIds)
        } catch {
            errorMessage = "Не удалось обновить корзину"
        }
    }
}
