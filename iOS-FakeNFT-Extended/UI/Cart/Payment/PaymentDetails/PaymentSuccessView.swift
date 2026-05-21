//
//  PaymentSuccessView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 21.05.2026.
//

import SwiftUI

struct PaymentSuccessView: View {
    let onBackToCartTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            content
            
            Spacer()
            
            backButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.whiteYP)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Subviews

private extension PaymentSuccessView {
    var content: some View {
        VStack(spacing: 20) {
            AppIcon.successStub.image
                .resizable()
                .scaledToFit()
                .frame(width: 278, height: 278)
            
            Text(Constants.title)
                .font(.headline3)
                .foregroundStyle(.blackYP)
                .multilineTextAlignment(.center)
        }
    }
    
    var backButton: some View {
        Button(action: onBackToCartTap) {
            Text(Constants.backToCartButtonTitle)
                .font(.bodyBold)
                .foregroundStyle(.whiteYP)
                .padding(.vertical, 19)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.blackYP)
                )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

// MARK: - Constants

private extension PaymentSuccessView {
    enum Constants {
        static let title = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        static let backToCartButtonTitle = "Вернуться в корзину"
    }
}

// MARK: - Preview

#Preview {
    PaymentSuccessView(onBackToCartTap: {})
}
