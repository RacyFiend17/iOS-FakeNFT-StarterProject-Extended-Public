import SwiftUI

struct StatisticsNftCellView: View {
    let nft: Nft
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageView
            
            ratingView
                .padding(.top, 8)
            
            Text(nft.name)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.blackUniversalYP)
                .lineLimit(1)
                .padding(.top, 5)
            
            HStack(spacing: 0) {
                Text(priceText)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.blackUniversalYP)
                    .lineLimit(1)
                
                Spacer()
                
                AppIcon.cartAdd.image
                    .renderingMode(.template)
                    .foregroundStyle(Color.blackUniversalYP)
                    .frame(width: 40, height: 40)
            }
            .frame(height: 20)
        }
    }
}

private extension StatisticsNftCellView {
    
    var imageView: some View {
        ZStack(alignment: .topTrailing) {
            nftImage
            
            AppIcon.like.image
                .renderingMode(.template)
                .foregroundStyle(Color.whiteUniversalYP)
                .frame(width: 40, height: 40)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    var nftImage: some View {
        if let imageURL = nft.images.first {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                placeholderImage
            }
        } else {
            placeholderImage
        }
    }
    
    var placeholderImage: some View {
        AppIcon.nftStub.image
            .renderingMode(.original)
            .resizable()
            .scaledToFill()
    }
    
    var ratingView: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                AppIcon.star.image
                    .renderingMode(.template)
                    .foregroundStyle(index < nft.rating ? Color.yellowUniversalYP : Color.greyUniversalYP)
                    .frame(width: 12, height: 12)
            }
        }
    }
    
    var priceText: String {
        String(format: "%.2f ETH", nft.price)
    }
}

#Preview {
    StatisticsNftCellView(nft: StatisticsMockNftData.all[0])
        .frame(width: 108)
        .padding()
}
