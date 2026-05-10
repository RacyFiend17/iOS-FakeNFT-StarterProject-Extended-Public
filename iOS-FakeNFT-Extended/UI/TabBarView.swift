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

            TestCatalogView()
                .tabItem {
                    Label {
                        Text("Каталог")
                    } icon: {
                        Image("catalogYP")
                    }
                }

            Text("Корзина")
                .tabItem {
                    Label {
                        Text("Корзина")
                    } icon: {
                        Image("basketYP")
                    }
                }

            Text("Статистика")
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
