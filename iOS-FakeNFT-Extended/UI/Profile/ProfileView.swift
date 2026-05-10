import SwiftUI

struct ProfileView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var viewModel: ProfileViewModel?

    var body: some View {
        Group {
            if let viewModel {
                ProfileContentView(
                    viewModel: viewModel,
                    profileService: servicesAssembly.profileService
                )
            } else {
                ProgressView()
                    .task {
                        let viewModel = ProfileViewModel(
                            profileService: servicesAssembly.profileService
                        )
                        self.viewModel = viewModel
                        await viewModel.loadProfile()
                    }
            }
        }
    }
}

private struct ProfileContentView: View {
    @Bindable var viewModel: ProfileViewModel

    let profileService: ProfileService

    @State private var isEditingProfile = false

    var body: some View {
        NavigationStack {
            content
                .navigationDestination(isPresented: $isEditingProfile) {
                    if let profile = viewModel.profile {
                        ProfileEditView(
                            viewModel: ProfileEditViewModel(
                                profile: profile,
                                profileService: profileService
                            ),
                            onSave: { updatedProfile in
                                viewModel.applyUpdatedProfile(updatedProfile)
                            }
                        )
                    }
                }
        }
        .task {
            if viewModel.state == .idle {
                await viewModel.loadProfile()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.whiteYP)

        case .loaded:
            if let profile = viewModel.profile {
                loadedView(profile)
            }

        case .failed(let message):
            VStack(spacing: 16) {
                Text(message)
                    .font(.bodyRegular)
                    .foregroundStyle(.blackYP)

                Button("Повторить") {
                    Task {
                        await viewModel.retry()
                    }
                }
                .font(.bodySemibold)
                .foregroundStyle(.blueUniversalYP)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.whiteYP)
        }
    }

    private func loadedView(_ profile: Profile) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 16) {
                    ProfileAvatarView(
                        avatarURLString: profile.avatar,
                        size: 70
                    )

                    VStack(alignment: .leading, spacing: 20) {
                        Text(profile.name)
                            .font(.headline3)
                            .foregroundStyle(.blackYP)
                            .padding(.top, 18)

                        Text(profile.description)
                            .font(.caption2)
                            .foregroundStyle(.blackYP)
                            .fixedSize(horizontal: false, vertical: true)

                        ProfileWebsiteView(website: profile.website)
                    }

                    Spacer()

                    Button {
                        isEditingProfile = true
                    } label: {
                        Image("editYP")
                            .resizable()
                            .frame(width: 42, height: 42)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)

                VStack(spacing: 0) {
                    ProfileMenuRowView(
                        title: "Мои NFT",
                        count: profile.nfts.count
                    )

                    ProfileMenuRowView(
                        title: "Избранные NFT",
                        count: profile.likes.count
                    )
                }
                .padding(.top, 40)
                .padding(.horizontal, 16)
            }
        }
        .background(.whiteYP)
    }
}

private struct ProfileWebsiteView: View {
    let website: String

    var body: some View {
        if let url = URL(string: website), !website.isEmpty {
            Link(website, destination: url)
                .font(.caption3)
                .foregroundStyle(.blueUniversalYP)
        } else {
            EmptyView()
        }
    }
}

#if DEBUG
private final class MockProfileService: ProfileService {
    func loadProfile() async throws -> Profile {
        Profile.preview
    }

    func updateProfile(_ profile: Profile) async throws -> Profile {
        profile
    }
}

private extension Profile {
    static let preview = Profile(
        id: "1",
        name: "Joaquin Phoenix",
        avatar: "https://code.s3.yandex.net/Mobile/iOS/NFT/avatars/1.png",
        description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "Joaquin Phoenix.com",
        nfts: Array(repeating: "nft", count: 112),
        likes: Array(repeating: "like", count: 11)
    )
}

#Preview("Profile") {
    let profileService = MockProfileService()
    let viewModel = ProfileViewModel(profileService: profileService)

    ProfileContentView(
        viewModel: viewModel,
        profileService: profileService
    )
    .task {
        await viewModel.loadProfile()
    }
}
#endif
