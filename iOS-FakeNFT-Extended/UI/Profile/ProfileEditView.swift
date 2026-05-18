import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var viewModel: ProfileEditViewModel

    let onSave: (Profile) -> Void

    @State private var isShowingPhotoActions = false
    @State private var isShowingPhotoURLAlert = false
    @State private var isShowingExitConfirmation = false
    @State private var photoURLInput = ""

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    avatarSection

                    ProfileInputField(
                        title: "Имя",
                        text: $viewModel.name,
                        axis: .horizontal
                    )

                    ProfileInputField(
                        title: "Описание",
                        text: $viewModel.description,
                        axis: .vertical
                    )

                    ProfileInputField(
                        title: "Сайт",
                        text: $viewModel.website,
                        axis: .horizontal
                    )

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
            }
            .background(.whiteYP)

            VStack {
                Spacer()

                Button {
                    Task {
                        if let updatedProfile = await viewModel.save() {
                            onSave(updatedProfile)
                            dismiss()
                        }
                    }
                } label: {
                    Text("Сохранить")
                        .font(.bodySemibold)
                        .foregroundStyle(.whiteYP)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(.blackYP)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(viewModel.isSaving)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }

            if viewModel.isSaving {
                Color.blackUniversalYP
                    .opacity(0.45)
                    .ignoresSafeArea()

                ProgressView()
                    .tint(.whiteUniversalYP)
            }
        }
        .background(.whiteYP)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    close()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.bodySemibold)
                        .foregroundStyle(.blackYP)
                }
            }
        }
        .confirmationDialog(
            "Фото профиля",
            isPresented: $isShowingPhotoActions,
            titleVisibility: .visible
        ) {
            Button("Изменить фото") {
                photoURLInput = viewModel.avatar
                isShowingPhotoURLAlert = true
            }

            Button("Удалить фото", role: .destructive) {
                viewModel.removeAvatar()
            }

            Button("Отмена", role: .cancel) {}
        }
        .alert("Ссылка на фото", isPresented: $isShowingPhotoURLAlert) {
            TextField("http://www.example.com", text: $photoURLInput)

            Button("Отмена", role: .cancel) {}

            Button("Сохранить") {
                viewModel.updateAvatar(with: photoURLInput)
            }
        }
        .alert("Уверены, что хотите выйти?", isPresented: $isShowingExitConfirmation) {
            Button("Остаться", role: .cancel) {}

            Button("Выйти", role: .destructive) {
                dismiss()
            }
        }
        .alert(
            "Ошибка",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )
        ) {
            Button("ОК", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var avatarSection: some View {
        HStack {
            Spacer()

            Button {
                isShowingPhotoActions = true
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    ProfileAvatarView(
                        avatarURLString: viewModel.avatar,
                        size: 70
                    )

                    Image("addFotoYP")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .buttonStyle(.plain)

            Spacer()
        }
    }

    private func close() {
        if viewModel.hasUnsavedChanges {
            isShowingExitConfirmation = true
        } else {
            dismiss()
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
        nfts: ["1", "2"],
        likes: ["3", "4"]
    )
}

#Preview {
    NavigationStack {
        ProfileEditView(
            viewModel: ProfileEditViewModel(
                profile: .preview,
                profileService: MockProfileService()
            ),
            onSave: { _ in }
        )
    }
}
#endif
