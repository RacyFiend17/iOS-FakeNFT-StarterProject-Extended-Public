//
//  CurrencyServiceStub.swift
//  iOS-FakeNFT-ExtendedTests
//
//  Created by Алла on 16.05.2026.
//

@testable import iOS_FakeNFT_Extended

final class CurrencyServiceStub: CurrencyService {
    private let result: Result<[Currency], Error>
    
    init(currencies: [Currency]) {
        self.result = .success(currencies)
    }
    
    init(error: Error) {
        self.result = .failure(error)
    }
    
    func loadCurrencies() async throws -> [Currency] {
        try result.get()
    }
}
