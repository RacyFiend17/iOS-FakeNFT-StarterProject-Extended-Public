//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import SwiftUI

@MainActor
@Observable
final class CatalogViewModel {
    
    private let service: CatalogService
    
    var state: CatalogState = .loading
    
    private let sortKey = "catalog_sort"
    
    private var collections: [Collection] = []
    
    var sortOption: CatalogSortOption {
        get {
            let rawValue = UserDefaults.standard.string(forKey: sortKey)
            return CatalogSortOption(rawValue: rawValue ?? "") ?? .byNftCount
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: sortKey)
            applySorting()
        }
    }
    
    init(service: CatalogService) {
        self.service = service
    }
    
    func load() async {
        state = .loading
        
        do {
            let collections = try await service.loadCollections()
            
            self.collections = collections
            applySorting()
            
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func updateSort(_ option: CatalogSortOption) {
        sortOption = option
    }
    
    private func applySorting() {
        let sorted: [Collection]
        
        switch sortOption {
        case .byName:
            sorted = collections.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            
        case .byNftCount:
            sorted = collections.sorted {
                $0.numberOfUniqueNFTs > $1.numberOfUniqueNFTs
            }
        }
        
        state = sorted.isEmpty ? .empty : .loaded(sorted)  
    }
}
