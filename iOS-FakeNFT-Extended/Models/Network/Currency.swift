//
//  Currency.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 11.05.2026.
//

import Foundation

struct Currency: Decodable, Sendable {
    let id: String
    let title: String
    let name: String
    let imageUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case imageUrl = "image"
    }
}
