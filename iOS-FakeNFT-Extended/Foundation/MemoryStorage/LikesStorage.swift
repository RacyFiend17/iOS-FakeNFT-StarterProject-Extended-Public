//
//  LikesStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 24.05.2026.
//

import Foundation

@Observable
final class LikesStorage {

    private let key = "liked_nft_ids"

    private(set) var likedIds: Set<String> = []

    init() {
        load()
    }

    func isLiked(id: String) -> Bool {
        likedIds.contains(id)
    }

    func toggle(id: String) {
        if likedIds.contains(id) {
            likedIds.remove(id)
        } else {
            likedIds.insert(id)
        }
        save()
    }
    
    func remove(id: String) {
        likedIds.remove(id)
        save()
    }
    
    func replace(with ids: [String]) {
        likedIds = Set(ids)
        save()
    }

    private func save() {
        UserDefaults.standard.set(
            Array(likedIds),
            forKey: key
        )
    }

    private func load() {
        let ids = UserDefaults.standard.stringArray(
            forKey: key
        ) ?? []

        likedIds = Set(ids)
    }
}
