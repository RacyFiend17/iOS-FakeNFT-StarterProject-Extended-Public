//
//  StatisticsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Илья Лобастов on 08.05.2026.
//
import SwiftUI

struct StatisticsView: View {
    private let users = StatisticsMockData.users

    var body: some View {
        NavigationStack {
            Text("Пользователей: \(users.count)")
                .navigationTitle("Статистика")
        }
    }
}

#Preview {
    StatisticsView()
}
