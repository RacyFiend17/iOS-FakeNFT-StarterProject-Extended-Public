import SwiftUI

struct ProfileAvatarView: View {
    let avatarURLString: String
    let size: CGFloat

    var body: some View {
        Group {
            if let url = URL(string: avatarURLString), !avatarURLString.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure:
                        Image("userFotoStubYP")
                            .resizable()
                            .scaledToFill()

                    @unknown default:
                        Image("userFotoStubYP")
                            .resizable()
                            .scaledToFill()
                    }
                }
            } else {
                Image("userFotoStubYP")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
