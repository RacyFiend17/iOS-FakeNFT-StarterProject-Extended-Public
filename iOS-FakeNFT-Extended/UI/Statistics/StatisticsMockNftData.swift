import Foundation

enum StatisticsMockNftData {
    
    static let all: [Nft] = [
        makeNft(id: "1", name: "Archie", rating: 2, price: 1.78),
        makeNft(id: "2", name: "Emma", rating: 2, price: 1.78),
        makeNft(id: "3", name: "Stella", rating: 2, price: 1.78),
        makeNft(id: "4", name: "Toast", rating: 2, price: 1.78),
        makeNft(id: "5", name: "Zeus", rating: 2, price: 1.78),
        makeNft(id: "6", name: "Luna", rating: 3, price: 2.10),
        makeNft(id: "7", name: "Milo", rating: 4, price: 0.95),
        makeNft(id: "8", name: "Oscar", rating: 5, price: 3.20),
        makeNft(id: "9", name: "Pixel", rating: 3, price: 1.25),
        makeNft(id: "10", name: "Neo", rating: 4, price: 2.40),
        makeNft(id: "11", name: "Ruby", rating: 2, price: 0.80),
        makeNft(id: "12", name: "Moon", rating: 5, price: 4.15),
        makeNft(id: "13", name: "Sky", rating: 3, price: 1.45),
        makeNft(id: "14", name: "Max", rating: 4, price: 2.05),
        makeNft(id: "15", name: "Leo", rating: 2, price: 1.10)
    ]
    
    static func nfts(for ids: [String]) -> [Nft] {
        let nftsByID = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
        return ids.compactMap { nftsByID[$0] }
    }
    
    private static func makeNft(
        id: String,
        name: String,
        rating: Int,
        price: Double
    ) -> Nft {
        Nft(
            createdAt: "",
            name: name,
            images: [],
            rating: rating,
            description: "",
            price: price,
            author: "",
            website: "",
            id: id
        )
    }
}
