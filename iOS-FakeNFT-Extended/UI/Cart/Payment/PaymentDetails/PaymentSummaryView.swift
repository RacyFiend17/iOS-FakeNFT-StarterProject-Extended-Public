//
//  PaymentSummaryView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 12.05.2026.
//

import SwiftUI

struct PaymentSummaryView: View {
    let isPayButtonEnabled: Bool
    let onAgreementTap: () -> Void
    let onPayTap: () -> Void

    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            textView
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

private extension PaymentSummaryView {
    var textView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Constants.text)
                .font(.caption2)
                .foregroundStyle(.blackYP)
            
            Button(action: onAgreementTap) {
                Text(Constants.agreement)
                    .font(.caption2)
                    .foregroundStyle(.blueUniversalYP)
            }
            .buttonStyle(.plain)
        }
    }
    
    var paymentButton: some View {
        Button(action: onPayTap) {
            Text(Constants.paymentButtonTitle)
                .font(.bodyBold)
                .foregroundStyle(.whiteYP)
                .padding(.vertical, 19)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.blackYP)
                )
        }
        .disabled(!isPayButtonEnabled)
        .buttonStyle(.plain)
    }
}

// MARK: - Constants

private extension PaymentSummaryView {
    enum Constants {
        static let text = "Совершая покупку, вы соглашаетесь с условиями"
        static let agreement = "Пользовательского соглашения"
        static let paymentButtonTitle = "Оплатить"
    }
}

// MARK: - Preview

#Preview("Pay disabled") {
    PaymentSummaryView(
        isPayButtonEnabled: false,
        onAgreementTap: {},
        onPayTap: {}
    )
}

#Preview("Pay enabled") {
    PaymentSummaryView(
        isPayButtonEnabled: true,
        onAgreementTap: {},
        onPayTap: {}
    )
}
