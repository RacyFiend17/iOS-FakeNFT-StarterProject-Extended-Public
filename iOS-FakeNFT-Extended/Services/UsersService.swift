import Foundation

protocol UsersService {
    func loadUsers() async throws -> [StatisticsUser]
}

actor UsersServiceImpl: UsersService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUsers() async throws -> [StatisticsUser] {
        let request = UsersRequest()
        return try await networkClient.send(request: request)
    }
}
