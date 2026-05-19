//
//  CollectionDetailsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import SwiftUI

struct CollectionDetailsView: View {
    
    @Environment(ServicesAssembly.self)
    private var servicesAssembly
    
    @Environment(\.dismiss) private var dismiss
    
    @State
    private var viewModel: CollectionDetailsViewModel
    
    let collection: Collection
    
    init(collection: Collection) {
        self.collection = collection
        
        _viewModel = State(
            initialValue: CollectionDetailsViewModel(
                collection: collection,
                service: CollectionService(
                    networkClient: DefaultNetworkClient()
                )
            )
        )
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 9),
        GridItem(.flexible(), spacing: 9),
        GridItem(.flexible(), spacing: 9)
    ]
    
    var body: some View {
        
        Group {
            switch viewModel.state {
            case .loading:
                customProgressView
            case .loaded:
                content
            case .error(let message):
                VStack(spacing: 16) {
                    Text("Ошибка")
                    
                    Text(message)
                    
                    Button("Повторить") {
                        Task {
                            await viewModel.load()
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                        AppIcon.chevronLeft.image
                        .tint(Color(.blackYP))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }
}

private extension CollectionDetailsView {
    
    var content: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                cover
                info
                grid
            }
        }
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    var cover: some View {
        
        AsyncImage(url: collection.cover) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            customProgressView
        }
        .frame(height: 310)
        .frame(maxWidth: .infinity)
        .clipped()
        .cornerRadius(16)
    }
    
    var info: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(collection.name)
                .font(.headline3)
            
            HStack(spacing: 0) {
                Text ("Автор коллекции: ")
                    .font(.caption2)
                    .foregroundStyle(Color(.blackYP))
                Button {
                    UIApplication.shared.open(collection.website)
                } label: {
                    Text("\(collection.author)")
                        .font(.caption3)
                        .foregroundStyle(.blue)
                }
            }
            
            Text(collection.description)
                .font(.caption2)
                .foregroundStyle(Color(.blackYP))
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 24)
    }
    
    var grid: some View {
        
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: 28,
        ) {
            ForEach(viewModel.nfts) { nft in
                
                NftCellView(nft: nft)
            }
        }
        .padding(.horizontal, 16)
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
