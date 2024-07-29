//
//  ContentView.swift
//  By_Alya
//
//  Created by şeyma gizem sivri on 22.07.2024.
//


import SwiftUI
import WebKit

class ContentViewModel: ObservableObject {
    @Published var selectedTabIndex: Int = 0
    @Published var webView: WKWebView? = nil
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    private let tabImageNames: [String] = ["arrow.backward.circle", "arrow.forward.circle", "", "cart", "storefront"]
    private let tabLabels: [String] = ["Geri", "İleri", "", "Ürünler", "Mağaza"]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                WebView(url: URL(string: "https://www.byalyametal.com")!, webView: $viewModel.webView)
                    .onAppear {
                        viewModel.webView?.navigationDelegate = WebViewNavigationDelegate()
                    }

                VStack {
                    Spacer()

                    // Tab Bar
                    ZStack {
                        HStack(spacing: 5) {
                            ForEach(0..<tabImageNames.count, id: \.self) { itemIndex in
                                Button(action: {
                                    viewModel.selectedTabIndex = itemIndex
                                    handleTabSelection(index: itemIndex)
                                }) {
                                    Spacer()
                                    VStack {
                                        Image(systemName: tabImageNames[itemIndex])
                                            .font(.system(size: 35, weight: .bold))
                                            .foregroundColor(viewModel.selectedTabIndex == itemIndex ? Color.white : Color.gray)
                                        Text(tabLabels[itemIndex])
                                            .font(.caption)
                                            .foregroundColor(viewModel.selectedTabIndex == itemIndex ? Color.white : Color.gray)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 80)
                        .background(Color(red: 132/255, green: 129/255, blue: 128/255))
                        .padding(.top, 30)

                        // Transparan daire
                        ZStack {
                            Circle()
                                .fill(Color.clear) // Arka plan transparan
                                .frame(width: 95, height: 95)

                            Circle()
                                .fill(Color(red: 132/255, green: 129/255, blue: 128/255))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image("alya_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                )
                        }
                        .offset(y: -20)
                    }
                    .frame(maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.bottom)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }

    internal func handleTabSelection(index: Int) {
        switch index {
        case 0: // Geri butonu
            if let webView = viewModel.webView, webView.canGoBack {
                webView.goBack()
            } else {
                // Geri gitmek mümkün değilse ana sayfaya dön
                viewModel.webView?.load(URLRequest(url: URL(string: "https://www.byalyametal.com")!))
            }
        case 1: // İleri butonu
            if let webView = viewModel.webView, webView.canGoForward {
                webView.goForward()
            }
        case 3: // Ürünler tabı
            if let url = URL(string: "https://www.byalyametal.com/urunler/") {
                viewModel.webView?.load(URLRequest(url: url))
            }
        case 4: // Mağaza tabı
            if let url = URL(string: "https://www.trendyol.com/magaza/by-alya-metal-m-297978?sst=0") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        default:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// WebViewNavigationDelegate to handle navigation events
class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Handle when navigation finishes
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Handle when navigation fails
    }
}
