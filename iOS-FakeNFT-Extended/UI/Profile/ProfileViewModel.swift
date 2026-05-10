import Foundation

@MainActor
@Observable
final class ProfileViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    private let profileService: ProfileService

    var state: State = .idle
    var profile: Profile?

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func loadProfile() async {
        state = .loading

        do {
            profile = try await profileService.loadProfile()
            state = .loaded
        } catch {
            state = .failed("Не удалось загрузить профиль")
        }
    }

    func retry() async {
        await loadProfile()
    }

    func applyUpdatedProfile(_ profile: Profile) {
        self.profile = profile
        state = .loaded
    }
}
