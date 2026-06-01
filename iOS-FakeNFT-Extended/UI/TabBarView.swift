import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            profile
            catalog
            cart
            statistics
        }
        .tint(.blueUniversalYP)
    }
}

// MARK: - Subviews

private extension TabBarView {
    var profile: some View {
        ProfileView()
            .tabItem {
                AppIcon.profile.image
                Text(Constants.profileTitle)
            }
    }

    var catalog: some View {
        CatalogView()
            .tabItem {
                AppIcon.catalog.image
                Text(Constants.catalogTitle)
            }
    }

    var cart: some View {
        CartFlowView()
            .tabItem {
                AppIcon.basket.image
                Text(Constants.cartTitle)
            }
    }

    var statistics: some View {
        StatisticsView()
            .tabItem {
                AppIcon.statistics.image
                Text(Constants.statisticsTitle)
            }
    }
}

// MARK: - Constants

private extension TabBarView {
    enum Constants {
        static let profileTitle = "Профиль"
        static let catalogTitle = "Каталог"
        static let cartTitle = "Корзина"
        static let statisticsTitle = "Статистика"
    }
}
