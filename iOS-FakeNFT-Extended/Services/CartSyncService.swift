import Foundation

protocol CartSyncService {
    func updateOrderCart(nftId: String, isInCart: Bool) async throws
}

actor OrderCartSyncService: CartSyncService {
    private let orderService: OrderService

    init(orderService: OrderService) {
        self.orderService = orderService
    }

    func updateOrderCart(nftId: String, isInCart: Bool) async throws {
        let order = try await orderService.loadOrder()
        var nftIds = order.nfts

        if isInCart {
            if !nftIds.contains(nftId) {
                nftIds.append(nftId)
            }
        } else {
            nftIds.removeAll { $0 == nftId }
        }

        _ = try await orderService.updateOrder(nftIds: nftIds)
    }
}
