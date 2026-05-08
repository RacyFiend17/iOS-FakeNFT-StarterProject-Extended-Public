import SwiftUI

struct StatisticsView: View {
    private let users = StatisticsMockData.users

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(Array(users.enumerated()), id: \.element.id) { index, user in
                        StatisticsUserRow(
                            position: index + 1,
                            user: user
                        )
                    }
                }
                .padding(.top, 20)
            }
            .background(.whiteUniversalYP)
            .navigationTitle("Статистика")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    StatisticsView()
}
