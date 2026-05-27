import Foundation

protocol ProfileService {
    func loadProfile() async throws -> Profile
    func updateProfile(_ profile: Profile) async throws -> Profile
}

actor ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile() async throws -> Profile {
        let request = ProfileRequest()
        return try await networkClient.send(request: request)
    }

    func updateProfile(_ profile: Profile) async throws -> Profile {
        let request = UpdateProfileRequest(profile: profile)
        return try await networkClient.send(request: request)
    }
}
