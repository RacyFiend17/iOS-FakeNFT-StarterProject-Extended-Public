////
////  LikedNftStorage.swift
////  iOS-FakeNFT-Extended
////
////  Created by Дмитрий Перчемиди on 24.05.2026.
////
//
//import Foundation
//
//protocol LikedNftStorageProtocol: AnyObject {
//    func isLiked(id: String) -> Bool
//    func toggle(id: String)
//}
//
//final class LikedNftStorage: LikedNftStorageProtocol {
//
//    private let key = "liked_nfts"
//
//    private var likedIds: Set<String> {
//        get {
//            let array = UserDefaults.standard.stringArray(forKey: key) ?? []
//            return Set(array)
//        }
//        set {
//            UserDefaults.standard.set(Array(newValue), forKey: key)
//        }
//    }
//
//    func isLiked(id: String) -> Bool {
//        likedIds.contains(id)
//    }
//
//    func toggle(id: String) {
//
//        var ids = likedIds
//
//        if ids.contains(id) {
//            ids.remove(id)
//        } else {
//            ids.insert(id)
//        }
//
//        likedIds = ids
//    }
//}
