import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    @State
    private var likesStorage = LikesStorage()
    
    @State
    private var cartNftStorage = CartNftStorage()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
        }
        .environment(likesStorage)
        .environment(cartNftStorage)
    }
}
