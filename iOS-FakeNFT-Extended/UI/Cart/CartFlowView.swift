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
    
    var body: some View {
        NavigationStack {
            CartAssembly(
                onPaymentTap: {
                    isPaymentPresented = true
                }
            )
            .navigationDestination(isPresented: $isPaymentPresented) {
                PaymentAssembly()
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}
