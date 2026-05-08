import SwiftUI

struct StatisticsView: View {
    private let users = StatisticsMockData.users

    var body: some View {
        NavigationStack {
            StatisticsUserRow(
                position: 1,
                user: users[0]
            )
            .navigationTitle("Статистика")
        }
    }
}

#Preview {
    StatisticsView()
}
