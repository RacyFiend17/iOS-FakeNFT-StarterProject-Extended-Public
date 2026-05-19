import SwiftUI

struct ProfileMenuRowView: View {
    let title: String
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
