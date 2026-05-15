//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import Foundation

protocol CatalogService {
    func loadCollections() async throws -> [Collection]
}

actor CatalogServiceImpl: CatalogService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCollections() async throws -> [Collection] {
        let request = CollectionsRequest()
        return try await networkClient.send(request: request)
    }
}
