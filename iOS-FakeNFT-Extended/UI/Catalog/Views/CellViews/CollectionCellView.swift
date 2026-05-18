//
//  CollectionCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import SwiftUI

struct CollectionCellView: View {
    
    let collection: Collection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            AsyncImage(url: collection.cover) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blackYP))
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text("\(collection.name) (\(collection.nfts.count))")
                .font(.bodyBold)
                .foregroundStyle(.blackYP)
                .padding(.bottom, 13)
        }
    }
}
