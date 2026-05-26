//
//  ShimmerModifier.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 24.05.2026.
//

import SwiftUI

struct PulseShimmer: ViewModifier {
    
    @State private var opacity: Double = 0.4
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.9)
                    .repeatForever(autoreverses: true)
                ) {
                    opacity = 0.9
                }
            }
    }
}

extension View {
    func pulseShimmer() -> some View {
        self.modifier(PulseShimmer())
    }
}
