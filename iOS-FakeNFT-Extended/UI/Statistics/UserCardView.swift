import SwiftUI

struct UserCardView: View {
    let user: StatisticsUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            userInfoView
                .padding(.top, 22)
            
            Text(user.description)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color.blackUniversalYP)
                .lineSpacing(2)
                .padding(.top, 20)
            
            websiteButton
                .padding(.top, 28)
            
            collectionButton
                .padding(.top, 41)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.whiteUniversalYP)
        .navigationBarTitleDisplayMode(.inline)
        .tint(.blackYP)
    }
}

// MARK: - Subviews

private extension UserCardView {
    
    var userInfoView: some View {
        HStack(spacing: 16) {
            avatarView
            
            Text(user.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.blackUniversalYP)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    var websiteButton: some View {
        if let websiteURL = user.websiteURL {
            NavigationLink {
                UserWebsiteView(url: websiteURL)
            } label: {
                websiteButtonContent
            }
            .buttonStyle(.plain)
        } else {
            websiteButtonContent
                .opacity(0.5)
        }
    }
    
    var websiteButtonContent: some View {
        Text("Перейти на сайт пользователя")
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(Color.blackUniversalYP)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color.whiteUniversalYP)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blackUniversalYP, lineWidth: 1)
            }
    }
    
    var collectionButton: some View {
        NavigationLink {
            UsersCollectionView(user: user)
        } label: {
            HStack(spacing: 0) {
                Text("Коллекция NFT  (\(user.nfts.count))")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.blackUniversalYP)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(Color.blackUniversalYP)
            }
            .frame(height: 44)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var avatarView: some View {
        if let avatarURL = user.avatarURL {
            AsyncImage(url: avatarURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                placeholderAvatarImage
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())
        } else {
            placeholderAvatarImage
                .frame(width: 70, height: 70)
                .clipShape(Circle())
        }
    }
    
    var placeholderAvatarImage: some View {
        Image(.userFotoStubYP)
            .renderingMode(.original)
            .resizable()
            .scaledToFill()
    }
}
