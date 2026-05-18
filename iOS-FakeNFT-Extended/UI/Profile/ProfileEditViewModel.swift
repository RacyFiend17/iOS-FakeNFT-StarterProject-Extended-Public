import Foundation

@MainActor
@Observable
final class ProfileEditViewModel {
    private let profileService: ProfileService
    private let originalProfile: Profile

    var name: String
    var description: String
    var website: String
    var avatar: String

    var isSaving = false
    var errorMessage: String?

    init(profile: Profile, profileService: ProfileService) {
        self.originalProfile = profile
        self.profileService = profileService

        self.name = profile.name
        self.description = profile.description
        self.website = profile.website
        self.avatar = profile.avatar
    }

    var hasUnsavedChanges: Bool {
        name != originalProfile.name ||
        description != originalProfile.description ||
        website != originalProfile.website ||
        avatar != originalProfile.avatar
    }

    func save() async -> Profile? {
        isSaving = true
        defer { isSaving = false }

        let updatedProfile = Profile(
            id: originalProfile.id,
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nfts: originalProfile.nfts,
            likes: originalProfile.likes
        )

        do {
            return try await profileService.updateProfile(updatedProfile)
        } catch {
            errorMessage = "Не удалось сохранить изменения"
            return nil
        }
    }

    func updateAvatar(with url: String) {
        avatar = url
    }

    func removeAvatar() {
        avatar = ""
    }
}
