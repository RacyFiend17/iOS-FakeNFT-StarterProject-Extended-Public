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
    
    var body: some View {
        CartView(
            viewModel: CartViewModel(
                orderService: servicesAssembly.orderService,
                nftService: servicesAssembly.nftService
            )
        )
    }
}
