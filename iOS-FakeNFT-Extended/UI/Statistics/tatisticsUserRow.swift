//
//  tatisticsUserRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Илья Лобастов on 08.05.2026.
//
import SwiftUI

struct StatisticsUserRow: View {
    let position: Int
    let user: StatisticsUser

    var body: some View {
        HStack(spacing: 8) {
            Text("\(position)")
                .font(.system(size: 15))
                .foregroundStyle(.primary)
                .frame(width: 28, alignment: .leading)

            HStack(spacing: 8) {
                avatarView

                Text(user.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(user.rating)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 16)
            .frame(height: 88)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Subviews

private extension StatisticsUserRow {
    @ViewBuilder
    var avatarView: some View {
        if let avatarURL = user.avatarURL {
            AsyncImage(url: avatarURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                placeholderAvatar
            }
            .frame(width: 32, height: 32)
            .clipShape(Circle())
        } else {
            placeholderAvatar
        }
    }

    var placeholderAvatar: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color(.systemGray3))
            .frame(width: 32, height: 32)
    }
}

// MARK: - Preview

#Preview {
    StatisticsUserRow(
        position: 1,
        user: StatisticsMockData.users[0]
    )
    .padding(.vertical)
    .preferredColorScheme(.light)
}
