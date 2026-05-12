//
//  PaymentCurrencyList.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 12.05.2026.
//

import SwiftUI

struct PaymentCurrencyList: View {
    let currencies: [Currency]
    let isSelected: (Currency) -> Bool
    
    private let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible())
    ]
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 7) {
                ForEach(currencies, id: \.id) { currency in
                    PaymentCurrencyCell(
                        currency: currency,
                        isSelected: isSelected(currency)
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
    }
}

// MARK: - Preview

#Preview("No selection") {
    PaymentCurrencyList(
        currencies: Currency.mocks,
        isSelected: { _ in false }
    )
}

#Preview("With selection") {
    PaymentCurrencyList(
        currencies: Currency.mocks,
        isSelected: { currency in
            currency.id == Currency.bitcoin.id
        }
    )
}
