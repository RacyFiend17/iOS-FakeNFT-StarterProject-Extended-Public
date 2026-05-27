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
    
    // Обработчик добавления нфт в корзину
    var nftAddedToCart: ((String) -> Void) = {_ in}
    
    // Обработчик обновления корзины
    var nftCartToggled: ((String, Bool) -> Void) = { _, _ in }
    
    // Обработчик обновления избранного
    var nftLikeToggled: ((String, Bool) -> Void) = { _, _ in }
    
    let nft: Nft
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .topTrailing) {
                
                AsyncImage(url: nft.imagesUrls.first) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(
                                tint: .black
                            )
                        )
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
                    nftLikeToggled(nft.id, likesStorage.isLiked(id: nft.id))
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
                        nftAddedToCart(nft.id)
                        nftCartToggled(nft.id, cartNftStorage.contains(id: nft.id))
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
}
