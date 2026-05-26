import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var isSortDialogPresented = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(viewModel.sortedUsers.enumerated()), id: \.element.id) { index, user in
                    NavigationLink {
                        UserCardView(user: user)
                    } label: {
                        StatisticsUserRow(
                            position: index + 1,
                            user: user
                        )
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowInsets(
                        EdgeInsets(
                            top: 4,
                            leading: 0,
                            bottom: 4,
                            trailing: 0
                        )
                    )
                    .listRowBackground(Color.whiteUniversalYP)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
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
                    viewModel.sortByName()
                }

                Button("По рейтингу") {
                    viewModel.sortByRating()
                }

                Button("Закрыть", role: .cancel) {}
            }
        }
    }
}

#Preview {
    StatisticsView()
}
