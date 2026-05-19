import SwiftUI

struct CatalogView: View {
    
    @Environment(ServicesAssembly.self)
    private var servicesAssembly
    
    @State
    private var viewModel: CatalogViewModel?
    
    @State
    private var showSortDialog = false
    
    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSortDialog = true
                        } label: {
                            AppIcon.sort.image
                                .foregroundStyle(Color(.blackYP))
                        }
                    }
                }
                .confirmationDialog(
                    "Сортировка",
                    isPresented: $showSortDialog,
                    titleVisibility: .visible
                ) {
                    ForEach(CatalogSortOption.allCases, id: \.self) { option in
                        Button(option.title) {
                            viewModel?.updateSort(option)
                        }
                    }
                    
                    Button("Закрыть", role: .cancel) {
                        showSortDialog = false
                    }
                }
        }
        .task {
            if viewModel == nil {
                let vm = CatalogViewModel(
                    service: servicesAssembly.catalogService
                )
                
                viewModel = vm
                
                await vm.load()
            }
        }
    }
    
    var customProgressView: some View {
        ProgressView()
            .progressViewStyle(
                CircularProgressViewStyle(
                    tint: .black
                )
            )
    }
    
    @ViewBuilder
    private var content: some View {
        
        if let viewModel {
            
            switch viewModel.state {
                
            case .loading:
                customProgressView
                
            case .empty:
                Text("Коллекции отсутствуют")
                
            case .error(let message):
                VStack(spacing: 12) {
                    Text("Ошибка")
                    Text(message)
                    
                    Button("Повторить") {
                        Task {
                            await viewModel.load()
                        }
                    }
                }
                
            case .loaded(let collections):
                ScrollView {
                    LazyVStack(spacing: 8) {
                        
                        ForEach(collections) { collection in
                            
                            NavigationLink {
                                CollectionDetailsView(collection: collection)
                            } label: {
                                CollectionCellView(collection: collection)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
            }
        }
    }
}
