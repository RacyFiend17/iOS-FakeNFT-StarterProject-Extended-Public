//
//  CollectionsRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
}
