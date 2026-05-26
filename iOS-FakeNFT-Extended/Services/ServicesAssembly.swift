import Foundation

@Observable
@MainActor
final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var orderService: OrderService {
        OrderServiceImpl(
            networkClient: networkClient
        )
    }

    var catalogService: CatalogService {
        CatalogServiceImpl(
            networkClient: networkClient
        )
    }

    var currencyService: CurrencyService {
        CurrencyServiceImpl(
            networkClient: networkClient
        )
    }

    var collectionService: CollectionService {
        CollectionService(networkClient: networkClient)
    }
    
    var usersService: UsersService {
        UsersServiceImpl(networkClient: networkClient)
    }
    
    let likesStorage = LikesStorage()
}
