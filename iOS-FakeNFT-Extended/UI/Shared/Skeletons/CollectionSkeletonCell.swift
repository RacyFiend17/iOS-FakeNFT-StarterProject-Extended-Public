//
//  CollectionSkeletonCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 24.05.2026.
//


import SwiftUI

struct CollectionSkeletonCell: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Rectangle()
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Rectangle()
            .frame(height: 20)
            .frame(maxWidth: .infinity)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.top, 3)
        }
        .foregroundStyle(Color.gray.opacity(0.3))
        .pulseShimmer()
    }
}
