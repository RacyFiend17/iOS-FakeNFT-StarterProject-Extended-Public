//
//  Collection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import Foundation

struct Collection: Identifiable, Decodable, Sendable {
    let createdAt: String
    let name: String
    let cover: URL
    let nfts: [String]
    let description: String
    let author: String
    let website: URL
    let id: String
}


