import SwiftUI

struct StatisticsView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var isSortDialogPresented = false
    
    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.whiteYP))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isSortDialogPresented = true
                        } label: {
                            Image(.sortYP)
                                .foregroundStyle(.blackYP)
                        }
                        .disabled(viewModel.users.isEmpty)
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
        .background(.whiteYP)
        .tint(.blackYP)
        .task {
            await viewModel.loadUsers(service: servicesAssembly.usersService)
        }
    }
}

// MARK: - Subviews

private extension StatisticsView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
            
        case .loaded:
            if viewModel.sortedUsers.isEmpty {
                emptyView
            } else {
                usersList
            }
            
        case .failed:
            errorView
        }
    }
    
    var usersList: some View {
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
                .listRowBackground(Color(.whiteYP))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.whiteYP))
    }
    
    var loadingView: some View {
        ProgressView()
            .tint(.blackYP)
    }
    
    var emptyView: some View {
        Text("Пользователи не найдены")
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(Color(.blackYP))
    }
    
    var errorView: some View {
        VStack(spacing: 16) {
            Text("Не удалось загрузить рейтинг")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(.blackYP))

            Button {
                Task {
                    await viewModel.reloadUsers(service: servicesAssembly.usersService)
                }
            } label: {
                Text("Повторить")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(.whiteYP))
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color(.blackYP))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 16)
        }
        .background(Color(.whiteYP))
    }
}
