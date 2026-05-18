//
//  NFTCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 18.05.2026.
//

import SwiftUI

struct NftCellView: View {
    
    let nft: Nft
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .topTrailing) {
                
                AsyncImage(url: nft.images.first) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 108, height: 108)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button {
                    
                } label: {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                        .padding(11)
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
                        
                    } label: {
                        AppIcon.cartAdd.image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .tint(Color(.blackYP))
                    }
                }
            }
        }
        .frame(width: 108)
    }
}
