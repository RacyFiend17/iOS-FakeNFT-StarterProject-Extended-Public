//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class CatalogViewModel {
    
    private let service: CatalogService
    
    var state: CatalogState = .loading
    
    @AppStorage("catalog_sort")
    private var sortOptionRawValue: String = CatalogSortOption.byNftCount.rawValue
    
    var sortOption: CatalogSortOption {
        get {
            CatalogSortOption(rawValue: sortOptionRawValue) ?? .byNftCount
        }
        set {
            sortOptionRawValue = newValue.rawValue
            applySorting()
        }
    }
    
    private var collections: [Collection] = []
    
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
        let sortedCollections: [Collection]
        
        switch sortOption {
        case .byName:
            sortedCollections = collections.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            
        case .byNftCount:
            sortedCollections = collections.sorted {
                $0.nfts.count > $1.nfts.count
            }
        }
        
        if sortedCollections.isEmpty {
            state = .empty
        } else {
            state = .loaded(sortedCollections)
        }
    }
}
