//
//  CartSortStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 25.05.2026.
//

import Foundation

protocol CartSortStorage: AnyObject {
    var selectedSortOption: CartSortOption { get set }
}

final class UserDefaultsCartSortStorage: CartSortStorage {
    private let userDefaults: UserDefaults
    private let key = "cartSelectedSortOption"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var selectedSortOption: CartSortOption {
        get {
            guard let rawValue = userDefaults.string(forKey: key) else {
                return .name
            }
            
            return CartSortOption(rawValue: rawValue) ?? .name
        }
        
        set {
            userDefaults.set(newValue.rawValue, forKey: key)
        }
    }
}
