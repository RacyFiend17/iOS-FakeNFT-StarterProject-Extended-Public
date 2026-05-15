//
//  NftServiceStub.swift
//  iOS-FakeNFT-ExtendedTests
//
//  Created by Алла on 15.05.2026.
//

@testable import iOS_FakeNFT_Extended

final class NftServiceStub: NftService {
    enum StubError: Error {
        case missingNft(id: String)
    }
    
    private let nftsById: [String: Nft]
    
    init(nftsById: [String: Nft]) {
        self.nftsById = nftsById
    }
    
    func loadNft(id: String) async throws -> Nft {
        guard let nft = nftsById[id] else {
            throw StubError.missingNft(id: id)
        }
        
        return nft
    }
}
