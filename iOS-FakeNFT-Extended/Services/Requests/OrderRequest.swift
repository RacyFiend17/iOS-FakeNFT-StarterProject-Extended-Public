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
    
    var dto: Encodable? {
        UpdateOrderDto(nfts: nftIds)
    }
}

private struct UpdateOrderDto: Encodable {
    let nfts: [String]
}
