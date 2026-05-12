//
//  PaymentAssembly.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 12.05.2026.
//

import SwiftUI

/// Создает экран выбора валюты и передает в него собранную view model.
struct PaymentAssembly: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
    var body: some View {
        PaymentView(
            viewModel: PaymentViewModel(
                currencyService: servicesAssembly.currencyService
            )
        )
    }
}
