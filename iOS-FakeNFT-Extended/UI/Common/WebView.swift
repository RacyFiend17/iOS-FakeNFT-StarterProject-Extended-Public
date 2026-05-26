//
//  WebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 24.05.2026.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}

