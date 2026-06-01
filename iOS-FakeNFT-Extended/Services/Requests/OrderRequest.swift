//
//  OrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 04.05.2026.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct UpdateOrderRequest: NetworkRequest {
    let nftIds: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var headers: [String: String] {
        [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
    }
    
    var httpBody: Data? {
        nftIds
            .map { "nfts=\($0)" }
            .joined(separator: "&")
            .data(using: .utf8)
    }
}
