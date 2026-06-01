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

        let uniqueIds = Array(NSOrderedSet(array: ids)) as? [String] ?? []

        return try await withThrowingTaskGroup(of: (Int, Nft).self) { group in

            for (index, id) in uniqueIds.enumerated() {

                group.addTask {
                    let nft: Nft = try await self.networkClient.send(
                        request: NFTByIdRequest(id: id)
                    )

                    return (index, nft)
                }
            }

            var indexedNfts: [(Int, Nft)] = []

            for try await result in group {
                indexedNfts.append(result)
            }

            return indexedNfts
                .sorted { $0.0 < $1.0 }
                .map(\.1)
        }
    }
}
