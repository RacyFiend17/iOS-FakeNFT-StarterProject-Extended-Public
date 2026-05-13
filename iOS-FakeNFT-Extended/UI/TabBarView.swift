import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            profile
            catalog
            cart
            statistic
        }
        .tint(.blueUniversalYP)
    }
}

// MARK: - Subviews

private extension TabBarView {
    var profile: some View {
        Text(Constants.profileTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabItem {
                AppIcon.profile.image
                Text(Constants.profileTitle)
            }
    }
    
    var catalog: some View {
        TestCatalogView()
            .tabItem {
                AppIcon.catalog.image
                Text(Constants.catalogTitle)
            }
    }
    
    var cart: some View {
        Text(Constants.cartTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabItem {
                AppIcon.basket.image
                Text(Constants.cartTitle)
            }
    }
    
    var statistic: some View {
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
