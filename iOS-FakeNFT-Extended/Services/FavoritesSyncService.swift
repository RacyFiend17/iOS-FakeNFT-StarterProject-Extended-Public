import Foundation

protocol FavoritesSyncService {
    func updateProfileLike(nftId: String, isLiked: Bool) async throws
}

actor ProfileFavoritesSyncService: FavoritesSyncService {
    private let profileService: ProfileService

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func updateProfileLike(nftId: String, isLiked: Bool) async throws {
        let profile = try await profileService.loadProfile()
        var likes = profile.likes

        if isLiked {
            if !likes.contains(nftId) {
                likes.append(nftId)
            }
        } else {
            likes.removeAll { $0 == nftId }
        }

        let updatedProfile = Profile(
            id: profile.id,
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nfts: profile.nfts,
            likes: likes
        )

        _ = try await profileService.updateProfile(updatedProfile)
    }
}
