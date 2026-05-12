//
//  CartAssembly.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 05.05.2026.
//

import SwiftUI

/// Создает экран корзины и передает в него собранную view model.
struct CartAssembly: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
    private let onPaymentTap: () -> Void
    
    init(onPaymentTap: @escaping () -> Void = {}) {
        self.onPaymentTap = onPaymentTap
    }
    
    var body: some View {
        CartView(
            viewModel: CartViewModel(
                orderService: servicesAssembly.orderService,
                nftService: servicesAssembly.nftService
            ),
            onPaymentTap: onPaymentTap
        )
    }
}
