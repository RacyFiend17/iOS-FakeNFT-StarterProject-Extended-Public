//
//  CartSortStorageStub.swift
//  iOS-FakeNFT-ExtendedTests
//
//  Created by Алла on 25.05.2026.
//

import Foundation
@testable import iOS_FakeNFT_Extended

final class CartSortStorageStub: CartSortStorage {
    var selectedSortOption: CartSortOption
    
    init(selectedSortOption: CartSortOption = .name) {
        self.selectedSortOption = selectedSortOption
    }
}
