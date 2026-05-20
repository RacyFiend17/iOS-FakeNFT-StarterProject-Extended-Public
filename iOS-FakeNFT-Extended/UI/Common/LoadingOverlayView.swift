//
//  LoadingOverlayView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 20.05.2026.
//

import SwiftUI

struct LoadingOverlayView: View {
    var body: some View {
        ProgressView()
            .tint(.blackYP)
            .frame(width: 82, height: 82)
            .background(.grayLightYP)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    LoadingOverlayView()
}
