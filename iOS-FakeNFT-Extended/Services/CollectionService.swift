//
//  CollectionService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 18.05.2026.
//

import Foundation

protocol CollectionServiceProtocol: Sendable {
    func loadNfts(ids: [String]) async throws -> [Nft]
}

actor CollectionService: CollectionServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNfts(ids: [String]) async throws -> [Nft] {
        
        return try await withThrowingTaskGroup(of: Nft.self) { group in
            
            for id in ids {
                group.addTask {
                    try await self.networkClient.send(
                        request: NFTByIdRequest(id: id)
                    )
                }
            }
            
            var nfts: [Nft] = []
            
            for try await nft in group {
                nfts.append(nft)
            }
            
            return nfts
        }
    }
}
