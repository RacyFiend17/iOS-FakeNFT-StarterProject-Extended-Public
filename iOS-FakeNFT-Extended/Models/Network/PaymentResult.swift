//
//  PaymentResult.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 20.05.2026.
//

import Foundation

struct PaymentResult: Decodable, Sendable {
    let success: Bool
    let orderId: String
    let id: String
}
