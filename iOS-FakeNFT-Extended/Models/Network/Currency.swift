//
//  Currency.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 11.05.2026.
//

import Foundation

struct Currency: Decodable, Sendable {
    let id: String
    let title: String
    let name: String
    let imageUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id, title, name
        case imageUrl = "image"
    }
}

// MARK: - Currency Abbreviations

extension Currency {
    var displayName: String {
        switch title {
        case "Bitcoin": "BTC"
        case "Dogecoin": "DOGE"
        case "Ethereum": "ETH"
        default: name
        }
    }
    
    var displayTitle: String {
        switch title {
        case "Shiba_Inu": "Shiba Inu"
        default: title
        }
    }
}

// MARK: - Mocks

extension Currency {
    static let shibaInu = Currency(
        id: "0",
        title: "Shiba_Inu",
        name: "SHIB",
        imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png")!
    )

    static let cardano = Currency(
        id: "1",
        title: "Cardano",
        name: "ADA",
        imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Cardano_(ADA).png")!
    )

    static let tether = Currency(
        id: "2",
        title: "Tether",
        name: "USDT",
        imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Tether_(USDT).png")!
    )

    static let apeCoin = Currency(
        id: "3",
        title: "ApeCoin",
        name: "APE",
        imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/ApeCoin_(APE).png")!
    )

    static let solana = Currency(
        id: "4",
        title: "Solana",
        name: "SOL",
        imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Solana_(SOL).png")!
    )

    static let bitcoin = Currency(
        id: "5",
        title: "Bitcoin",
        name: "BITCOIN",
        imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Bitcoin_(BTC).png")!
    )

    static let dogecoin = Currency(
        id: "6",
        title: "Dogecoin",
        name: "DOGECOIN",
        imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Dogecoin_(DOGE).png")!
    )

    static let ethereum = Currency(
        id: "7",
        title: "Ethereum",
        name: "ETHEREUM",
        imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Ethereum_(ETH).png")!
    )

    static let mocks: [Currency] = [
        .bitcoin,
        .dogecoin,
        .tether,
        .apeCoin,
        .solana,
        .ethereum,
        .cardano,
        .shibaInu
    ]
}

