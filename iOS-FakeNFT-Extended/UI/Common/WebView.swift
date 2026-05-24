//
//  WebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 12.05.2026.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: urlString) else { return WKWebView() }
        
        let webView = WKWebView()
        
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}

