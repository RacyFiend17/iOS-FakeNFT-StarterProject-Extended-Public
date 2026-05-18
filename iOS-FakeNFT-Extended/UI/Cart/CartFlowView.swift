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
                    }
                )
                .toolbar(.hidden, for: .tabBar)
                .navigationDestination(isPresented: $isAgreementPresented) {
                    if let agreementURL = URL(string: Constants.agreementURLString) {
                        WebView(url: agreementURL)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }
        }
    }
}

// MARK: - Constants

private extension CartFlowView {
    enum Constants {
        static let agreementURLString = "https://yandex.ru/legal/practicum_termsofuse"
    }
}
