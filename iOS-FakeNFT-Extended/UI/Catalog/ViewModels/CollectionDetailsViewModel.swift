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
    
    private let collection: Collection
    private let service: CollectionServiceProtocol
    
    init(
        collection: Collection,
        service: CollectionServiceProtocol
    ) {
        self.collection = collection
        self.service = service
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
}
