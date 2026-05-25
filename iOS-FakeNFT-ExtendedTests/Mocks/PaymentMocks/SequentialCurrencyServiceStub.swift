//
//  SequentialCurrencyServiceStub.swift
//  iOS-FakeNFT-ExtendedTests
//
//  Created by Алла on 16.05.2026.
//

@testable import iOS_FakeNFT_Extended

final class SequentialCurrencyServiceStub: CurrencyService {
    enum StubError: Error {
        case noMoreResults
    }

    private var results: [Result<[Currency], Error>]

    init(results: [Result<[Currency], Error>]) {
        self.results = results
    }

    func loadCurrencies() async throws -> [Currency] {
        guard !results.isEmpty else {
            throw StubError.noMoreResults
        }

        return try results.removeFirst().get()
    }
}
