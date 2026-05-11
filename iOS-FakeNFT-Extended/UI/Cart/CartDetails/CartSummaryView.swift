//
//  CartSummaryView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 05.05.2026.
//

import SwiftUI

struct CartSummaryView: View {
    let totalCount: Int
    let totalPrice: Double
    let onPaymentTap: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 24) {
            summaryView
            paymentButton
        }
        .padding(16)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: 12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 12
            )
            .fill(.grayLightYP)
        )
    }
}

// MARK: - Subviews

private extension CartSummaryView {
    var summaryView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(totalCount) NFT")
                .font(.caption3)
                .foregroundStyle(.blackYP)
            
            Text(totalPrice.ethFormatted)
                .font(.bodyBold)
                .foregroundStyle(.greenUniversalYP)
        }
    }
    
    var paymentButton: some View {
        Button(action: onPaymentTap) {
            Text(Constants.paymentButtonTitle)
                .font(.bodyBold)
                .foregroundStyle(.whiteYP)
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.blackYP)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Constants

private extension CartSummaryView {
    enum Constants {
        static let paymentButtonTitle = "К оплате"
    }
}

#Preview {
    CartSummaryView(
        totalCount: 3,
        totalPrice: 5.34,
        onPaymentTap: {}
    )
}
