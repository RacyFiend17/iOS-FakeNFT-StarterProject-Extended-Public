import SwiftUI

struct StatisticsUserRow: View {
    let position: Int
    let user: StatisticsUser
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(position)")
                .font(.system(size: 15))
                .foregroundStyle(Color(.blackYP))
                .frame(width: 28, alignment: .leading)
            
            HStack(spacing: 8) {
                avatarView
                
                Text(user.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color(.blackYP))

                Spacer()
                
                Text("\(user.nfts.count)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color(.blackYP))
            }
            .padding(.horizontal, 16)
            .frame(height: 88)
            .background(Color(.grayLightYP))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Subviews

private extension StatisticsUserRow {
    @ViewBuilder
    var avatarView: some View {
        if let avatarURL = user.avatarURL {
            AsyncImage(url: avatarURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                placeholderAvatar
            }
            .frame(width: 32, height: 32)
            .clipShape(Circle())
        } else {
            placeholderAvatar
        }
    }
    
    var placeholderAvatar: some View {
        Image(.userFotoStubYP)
            .renderingMode(.original)
            .resizable()
            .scaledToFill()
            .frame(width: 32, height: 32)
            .clipShape(Circle())
    }
}
