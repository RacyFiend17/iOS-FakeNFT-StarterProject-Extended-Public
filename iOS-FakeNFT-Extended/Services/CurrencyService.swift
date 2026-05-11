//
//  CurrencyService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 11.05.2026.
//

import Foundation

protocol CurrencyService {
    func loadCurrencies() async throws -> [Currency]
}

actor CurrencyServiceImpl: CurrencyService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCurrencies() async throws -> [Currency] {
        let request = CurrenciesRequest()
        let currencies: [Currency] = try await networkClient.send(request: request)
        return currencies
    }
}
