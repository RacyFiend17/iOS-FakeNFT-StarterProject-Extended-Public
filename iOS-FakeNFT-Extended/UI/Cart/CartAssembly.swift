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
    @Environment(CartNftStorage.self) private var cartNftStorage
    
    private let onPaymentTap: () -> Void
    private let refreshTrigger: Bool
    @Binding private var isDeleteConfirmationPresented: Bool
    
    init(
        refreshTrigger: Bool = false,
        isDeleteConfirmationPresented: Binding<Bool> = .constant(false),
        onPaymentTap: @escaping () -> Void = {}
    ) {
        self.refreshTrigger = refreshTrigger
        _isDeleteConfirmationPresented = isDeleteConfirmationPresented
        self.onPaymentTap = onPaymentTap
    }
    
    var body: some View {
        CartView(
            viewModel: CartViewModel(
                orderService: servicesAssembly.orderService,
                nftService: servicesAssembly.nftService,
                cartNftStorage: cartNftStorage
            ),
            refreshTrigger: refreshTrigger,
            isDeleteConfirmationPresented: $isDeleteConfirmationPresented,
            onPaymentTap: onPaymentTap
        )
    }
}
