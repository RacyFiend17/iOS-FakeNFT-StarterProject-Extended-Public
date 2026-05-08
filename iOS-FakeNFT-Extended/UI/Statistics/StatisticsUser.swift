//
//  StatisticsUser.swift
//  iOS-FakeNFT-Extended
//
//  Created by Илья Лобастов on 08.05.2026.
//
import Foundation

struct StatisticsUser: Identifiable, Hashable {
    let id: String
    let name: String
    let avatarURL: URL?
    let rating: Int
}
