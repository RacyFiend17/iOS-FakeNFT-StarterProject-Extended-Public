//
//  PaymentCurrencyCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 12.05.2026.
//

import SwiftUI
import Kingfisher

struct PaymentCurrencyCell: View {
    let currency: Currency
    let isSelected: Bool
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 4) {
            currencyImage
            currencyName
            
            Spacer()
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 12)
        .background(.grayLightYP)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? .blackYP : .clear, lineWidth: 1)
        }
    }
}

// MARK: - Subviews

private extension PaymentCurrencyCell {
    var currencyImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(.blackUniversalYP)
                .frame(width: 36, height: 36)
            
            KFImage(currency.imageUrl)
                .placeholder {
                    ProgressView()
                        .tint(.blackYP)
                        .frame(width: 36, height: 36)
                        .background(.grayLightYP)
                }
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
        }
    }
    
    var currencyName: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(currency.displayTitle)
                .font(.caption2)
                .foregroundStyle(.blackYP)
            
            Text(currency.displayName)
                .font(.caption2)
                .foregroundStyle(.greenUniversalYP)
        }
    }
}

// MARK: - Preview

#Preview {
    PaymentCurrencyCell(
        currency: Currency.bitcoin,
        isSelected: false
    )
}

#Preview("Currency selected") {
    PaymentCurrencyCell(
        currency: Currency.shibaInu,
        isSelected: true
    )
}
