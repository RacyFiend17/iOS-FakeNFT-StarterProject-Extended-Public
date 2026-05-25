//
//  CompleteOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 21.05.2026.
//

import Foundation

struct CompleteOrderRequest: NetworkRequest {
    let nftIds: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod {
        .post
    }
    
    var httpBody: Data? {
        nftIds
            .map { "nfts=\($0)" }
            .joined(separator: "&")
            .data(using: .utf8)
    }
    
    var contentType: String? {
        "application/x-www-form-urlencoded"
    }
}
