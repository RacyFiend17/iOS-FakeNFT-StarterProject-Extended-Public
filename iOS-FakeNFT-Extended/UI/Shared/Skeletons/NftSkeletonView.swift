//
//  NftSkeletonView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 24.05.2026.
//

import SwiftUI

struct NftSkeletonView: View {

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(1, contentMode: .fit)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 10)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 10)
        }
        .redacted(reason: .placeholder)
        .pulseShimmer()
    }
    
    static var skeletonCover: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.3))
            .frame(maxWidth: .infinity)
            .frame(height: 310)
            .pulseShimmer()
    }
    
    static var skeletonInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 180, height: 20)

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 140, height: 14)

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 60)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .pulseShimmer()
    }
}
