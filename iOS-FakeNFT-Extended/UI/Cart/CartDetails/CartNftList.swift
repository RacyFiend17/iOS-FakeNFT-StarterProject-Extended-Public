//
//  CartNftList.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 05.05.2026.
//

import SwiftUI

struct CartNftList: View {
    let nfts: [Nft]
    let onDeleteTap: (Nft) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(nfts, id: \.id) { nft in
                    CartNftCell(nft: nft) {
                        onDeleteTap(nft)
                    }
                }
            }
        }
    }
}

#Preview {
    CartNftList(
        nfts: [.mock1, .mock2, .mock3],
        onDeleteTap: { _ in }
    )
}
