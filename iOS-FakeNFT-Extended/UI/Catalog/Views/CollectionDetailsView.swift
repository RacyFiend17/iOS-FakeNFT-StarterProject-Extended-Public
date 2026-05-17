//
//  CollectionDetailsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import SwiftUI

struct CollectionDetailsView: View {
    
    let collection: Collection
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                AsyncImage(url: collection.cover) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blackYP))
                }
                .frame(height: 310)
                .clipped()
                .cornerRadius(16)
                
                Text(collection.name)
                    .font(.headline3)
                
                Text("Автор коллекции:")
                    + Text(" \(collection.author)")
                    .foregroundStyle(.blue)
                
                Text(collection.description)
            }
            .padding()
        }
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
