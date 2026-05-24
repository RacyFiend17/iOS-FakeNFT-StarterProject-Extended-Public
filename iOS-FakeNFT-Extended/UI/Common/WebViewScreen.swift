//
//  WebViewScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 24.05.2026.
//

import SwiftUI

struct WebViewScreen: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    let urlString: String
    
    var body: some View {
        
        WebView(urlString: urlString)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        AppIcon.chevronLeft.image
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.black)
                    }
                }
            }
    }
}
