//
//  CatalogSortOption.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import Foundation

enum CatalogSortOption: String, CaseIterable {
    case byName
    case byNftCount
    
    var title: String {
        switch self {
        case .byName:
            return "По названию"
        case .byNftCount:
            return "По количеству NFT"
        }
    }
}
