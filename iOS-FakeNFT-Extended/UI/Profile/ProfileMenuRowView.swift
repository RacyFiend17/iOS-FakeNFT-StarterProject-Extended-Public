import SwiftUI

struct ProfileMenuRowView: View {
    let title: String
    let count: Int

    var body: some View {
        Button {
            // TODO: переход на экран списка NFT будет в следующих задачах эпика.
        } label: {
            HStack {
                Text("\(title) (\(count))")
                    .font(.bodyBold)
                    .foregroundStyle(.blackYP)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.bodySemibold)
                    .foregroundStyle(.blackYP)
            }
            .frame(height: 54)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
