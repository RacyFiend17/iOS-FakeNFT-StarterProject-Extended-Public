//
//  CurrenciesRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 11.05.2026.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
