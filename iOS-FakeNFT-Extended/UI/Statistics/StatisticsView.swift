import SwiftUI

struct StatisticsView: View {
    @State private var sortOption: StatisticsSortOption = .rating
    @State private var isSortDialogPresented = false

    private let users = StatisticsMockData.users

    private var sortedUsers: [StatisticsUser] {
        switch sortOption {
        case .rating:
            return users.sorted { $0.rating > $1.rating }
        case .name:
            return users.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(Array(sortedUsers.enumerated()), id: \.element.id) { index, user in
                        StatisticsUserRow(
                            position: index + 1,
                            user: user
                        )
                    }
                }
                .padding(.top, 20)
            }
            .background(.whiteUniversalYP)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSortDialogPresented = true
                    } label: {
                        Image(.sortYP)
                    }
                }
            }
            .confirmationDialog(
                "Сортировка",
                isPresented: $isSortDialogPresented,
                titleVisibility: .visible
            ) {
                Button("По имени") {
                    sortOption = .name
                }

                Button("По рейтингу") {
                    sortOption = .rating
                }

                Button("Закрыть", role: .cancel) {}
            }
        }
    }
}

#Preview {
    StatisticsView()
}
