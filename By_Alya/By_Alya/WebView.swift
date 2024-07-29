//
//  WebView.swift
//  By_Alya
//
//  Created by şeyma gizem sivri on 24.07.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var webView: WKWebView?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration())
        // WebView'in referansını bağla
        DispatchQueue.main.async {
            self.webView = webView
        }
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Bu alan boş bırakılabilir
    }

    internal func webViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        return configuration
    }
}




