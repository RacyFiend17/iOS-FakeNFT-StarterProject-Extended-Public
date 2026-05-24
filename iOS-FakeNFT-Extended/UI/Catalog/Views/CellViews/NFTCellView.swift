//
//  NFTCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 18.05.2026.
//

import SwiftUI

struct NftCellView: View {
    
    @Environment(LikesStorage.self)
    private var likesStorage
    
    @Environment(CartNftStorage.self)
    private var cartNftStorage
    
    let nft: Nft
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .topTrailing) {
                
                AsyncImage(url: nft.images.first) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    customProgressView
                }
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Button {
                    HapticService.shared.impact(.soft)
                    withAnimation(.spring(duration: 0.4)) {
                        likesStorage.toggle(id: nft.id)
                    }
                } label: {
                    AppIcon.like.image
                        .renderingMode(.template)
                        .foregroundStyle(
                            likesStorage.isLiked(id: nft.id) ? .red : .white
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < nft.rating
                              ? "star.fill"
                              : "star")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(nft.name)
                            .font(.bodyBold)
                            .lineLimit(1)
                        
                        Text("\(Int(nft.price)) ETH")
                            .font(.caption1)
                    }
                    
                    Spacer()
                    
                    Button {
                        HapticService.shared.impact(.medium)
                        withAnimation(.spring(duration: 0.4)) {
                            cartNftStorage.toggle(id: nft.id)
                        }
                    } label: {
                        (
                            cartNftStorage.contains(id: nft.id)
                            ? AppIcon.cartDelete.image
                            : AppIcon.cartAdd.image
                        )
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .tint(Color(.blackYP))
                    }
                }
            }
        }
    }
    
    var customProgressView: some View {
        ProgressView()
            .progressViewStyle(
                CircularProgressViewStyle(
                    tint: .black
                )
            )
    }
}
