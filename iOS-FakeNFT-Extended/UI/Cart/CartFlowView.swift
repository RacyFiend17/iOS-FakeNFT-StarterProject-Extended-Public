//
//  CartFlowView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 12.05.2026.
//

import SwiftUI

/// Управляет навигацией между экранами корзины и оплаты.
struct CartFlowView: View {
    @State private var isPaymentPresented = false
    @State private var isAgreementPresented = false
    @State private var isPaymentSuccessPresented = false
    
    var body: some View {
        NavigationStack {
            CartAssembly(
                onPaymentTap: {
                    isPaymentPresented = true
                }
            )
            .navigationDestination(isPresented: $isPaymentPresented) {
                PaymentAssembly(
                    onAgreementTap: {
                        isAgreementPresented = true
                    },
                    onPaymentSuccess: {
                        isPaymentSuccessPresented = true
                    }
                )
                .navigationDestination(isPresented: $isAgreementPresented) {
                    if let agreementURL = URL(string: Constants.agreementURLString) {
                        WebView(url: agreementURL)
                    }
                }
                .navigationDestination(isPresented: $isPaymentSuccessPresented) {
                    PaymentSuccessView(
                        onBackToCartTap: {
                            isPaymentSuccessPresented = false
                            isPaymentPresented = false
                        }
                    )
                }
            }
        }
        .toolbar(isPaymentPresented ? .hidden : .visible, for: .tabBar)
    }
}

// MARK: - Constants

private extension CartFlowView {
    enum Constants {
        static let agreementURLString = "https://yandex.ru/legal/practicum_termsofuse"
    }
}
