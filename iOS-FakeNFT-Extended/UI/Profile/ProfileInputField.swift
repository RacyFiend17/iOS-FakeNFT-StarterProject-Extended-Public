import SwiftUI

struct ProfileInputField: View {
    let title: String
    @Binding var text: String
    let axis: Axis

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline3)
                .foregroundStyle(.blackYP)

            Group {
                if axis == .vertical {
                    TextEditor(text: $text)
                        .font(.bodyRegular)
                        .foregroundStyle(.blackYP)
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                } else {
                    TextField("", text: $text)
                        .font(.bodyRegular)
                        .foregroundStyle(.blackYP)
                        .frame(height: 44)
                }
            }
            .padding(.horizontal, 12)
            .background(.grayLightYP)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
