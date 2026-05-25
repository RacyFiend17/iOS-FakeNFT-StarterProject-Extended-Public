//
//  CartNftStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 24.05.2026.
//

import Foundation

@Observable
final class CartNftStorage {

    private let key = "cart_nfts"

    private(set) var ids: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(ids), forKey: key)
        }
    }

    init() {
        let array = UserDefaults.standard.stringArray(forKey: key) ?? []
        self.ids = Set(array)
    }

    func contains(id: String) -> Bool {
        ids.contains(id)
    }

    func toggle(id: String) {
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
    }
}
