import SwiftUI

struct UsersCollectionView: View {
    let user: StatisticsUser

    var body: some View {
        Text("Коллекция NFT")
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(Color.blackUniversalYP)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.whiteUniversalYP)
            .navigationTitle("Коллекция NFT")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        UsersCollectionView(user: StatisticsMockData.users[0])
    }
}
