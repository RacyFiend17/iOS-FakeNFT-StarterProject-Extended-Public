import SwiftUI

struct MyNFTRowView: View {
    let nft: Nft

    private let imageSize: CGFloat = 108
    private let rowHeight: CGFloat = 140

    var body: some View {
        HStack(spacing: 20) {
            nftImage

            VStack(alignment: .leading, spacing: 4) {
                Spacer(minLength: 0)

                Text(nft.name)
                    .font(.titleBold)
                    .foregroundStyle(.blackYP)
                    .lineLimit(1)

                ratingView

                Text(authorText)
                    .font(.caption3)
                    .foregroundStyle(.blackYP)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 4) {
                Text("Цена")
                    .font(.caption3)
                    .foregroundStyle(.blackYP)

                Text(priceText)
                    .font(.titleBold)
                    .foregroundStyle(.blackYP)
                    .lineLimit(1)
            }
            .frame(width: 96, alignment: .leading)
        }
        .frame(height: rowHeight)
        .contentShape(Rectangle())
    }

    private var nftImage: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: nft.images.first) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: imageSize, height: imageSize)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                case .failure:
                    Image("nftStubYP")
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                @unknown default:
                    Image("nftStubYP")
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            Image("likeYP")
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.whiteUniversalYP)
                .padding(.top, 8)
                .padding(.trailing, 8)
        }
        .frame(width: imageSize, height: imageSize)
    }

    private var ratingView: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image("starYP")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(index <= nft.rating ? .yellowUniversalYP : .grayLightYP)
            }
        }
        .frame(height: 12)
    }

    private var authorText: String {
        nft.author.isEmpty ? "от John Doe" : "от \(nft.author)"
    }

    private var priceText: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: nft.price)
        let formattedPrice = formatter.string(from: number) ?? "\(nft.price)"

        return "\(formattedPrice) ETH"
    }
}
