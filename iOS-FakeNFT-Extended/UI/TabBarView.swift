import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label {
                        Text("Профиль")
                    } icon: {
                        Image("ProfileYP")
                    }
                }

            CatalogView()
                .tabItem {
                    Label {
                        Text("Каталог")
                    } icon: {
                        Image("catalogYP")
                    }
                }

            CartFlowView()
                .tabItem {
                    Label {
                        Text("Корзина")
                    } icon: {
                        Image("basketYP")
                    }
                }

            StatisticsView()
                .tabItem {
                    Label {
                        Text("Статистика")
                    } icon: {
                        Image("statistics")
                    }
                }
        }
    }
}
