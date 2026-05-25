//
//  DeleteNftConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 20.05.2026.
//

import SwiftUI

struct DeleteNftConfirmationView: View {
    let nft: Nft
    let onDeleteTap: () -> Void
    let onCancelTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                nftImage
                
                confirmationTitle
            }
            
            buttons
        }
    }
}

// MARK: - Subviews

private extension DeleteNftConfirmationView {
    @ViewBuilder
    var nftImage: some View {
        if let imageURL = nft.imagesUrls.first {
            AsyncImage(url: imageURL) { phase in
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
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(.grayLightYP)
                .frame(width: 108, height: 108)
        }
    }
    
    var confirmationTitle: some View {
        Text(Constants.confirmationText)
            .font(.caption2)
            .foregroundStyle(.blackYP)
            .multilineTextAlignment(.center)
    }
    
    var buttons: some View {
        HStack(spacing: 8) {
            Button(action: onDeleteTap) {
                Text(Constants.deleteButtonTitle)
                    .font(.bodyRegular)
                    .foregroundStyle(.redUniversalYP)
                    .frame(width: 127, height: 44)
                    .background(.blackYP)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button(action: onCancelTap) {
                Text(Constants.cancelButtonTitle)
                    .font(.bodyRegular)
                    .foregroundStyle(.whiteYP)
                    .frame(width: 127, height: 44)
                    .background(.blackYP)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

// MARK: - Constants

private extension DeleteNftConfirmationView {
    enum Constants {
        static let confirmationText = "Вы уверены, что хотите\nудалить объект из корзины?"
        static let deleteButtonTitle = "Удалить"
        static let cancelButtonTitle = "Вернуться"
    }
}

// MARK: - Preview

#Preview {
    DeleteNftConfirmationView(
        nft: Nft.mock1,
        onDeleteTap: {},
        onCancelTap: {}
    )
}
