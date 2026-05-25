//
//  CartNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 04.05.2026.
//

import SwiftUI

struct CartNftCell: View {
    let nft: Nft
    let onDeleteTap: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 20) {
            nftImageView
            
            VStack(alignment: .leading, spacing: 12) {
                nftNameAndRating
                nftPrice
            }
            
            Spacer()
            
            deleteCartButton
        }
        .padding(16)
    }
}

// MARK: - Subviews

private extension CartNftCell {
    var nftImageView: some View {
        AsyncImage(url: nft.imagesUrls.first) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .tint(.blackYP)
                    .frame(width: 108, height: 108)
                    .background(.grayLightYP)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                
            case .failure:
                Color.grayLightYP
                
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 108, height: 108)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    var nftNameAndRating: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(nft.name)
                .font(.bodyBold)
                .foregroundStyle(.blackYP)
            
            nftRating
        }
    }
    
    var nftRating: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                AppIcon.star.image
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(index <= normalizedRating ? .yellowUniversalYP : .grayLightYP)
            }
        }
    }
    
    var normalizedRating: Int {
        min(max(nft.rating, 0), 5)
    }
    
    var nftPrice: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(Constants.price)
                .font(.caption2)
            
            Text(nft.price.ethFormatted)
                .font(.bodyBold)
        }
        .foregroundStyle(.blackYP)
    }
    
    var deleteCartButton: some View {
        Button(action: onDeleteTap) {
            AppIcon.cartDelete.image
                .frame(width: 40, height: 40)
                .foregroundStyle(.blackYP)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Constants

private extension CartNftCell {
    enum Constants {
        static let price = "Цена"
    }
}

// MARK: - Preview

#Preview {
    CartNftCell(
        nft: .mock1,
        onDeleteTap: {}
    )
    .border(.blackYP, width: 1)
}
