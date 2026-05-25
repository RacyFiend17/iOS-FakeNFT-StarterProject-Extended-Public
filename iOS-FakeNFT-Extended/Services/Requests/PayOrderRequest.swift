//
//  PayOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 20.05.2026.
//

import Foundation

struct PayOrderRequest: NetworkRequest {
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
}
