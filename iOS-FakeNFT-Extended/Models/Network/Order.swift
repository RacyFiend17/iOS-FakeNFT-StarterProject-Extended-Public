//
//  Order.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 04.05.2026.
//

import Foundation

struct Order: Decodable, Sendable {
    let id: String
    let nfts: [String]
}
