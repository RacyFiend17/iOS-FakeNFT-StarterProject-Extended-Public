import SwiftUI

struct UserCardView: View {
    let user: StatisticsUser

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color(.systemGray3))
                .frame(width: 80, height: 80)

            Text(user.name)
                .font(.system(size: 22, weight: .bold))

            Text("Рейтинг: \(user.rating)")
                .font(.system(size: 17))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.whiteUniversalYP)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        UserCardView(user: StatisticsMockData.users[0])
    }
}
