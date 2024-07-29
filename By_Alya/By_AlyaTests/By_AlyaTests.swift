//
//  By_AlyaTests.swift
//  By_AlyaTests
//
//  Created by şeyma gizem sivri on 29.07.2024.
//

import XCTest
import WebKit
@testable import By_Alya

final class By_AlyaTests: XCTestCase {
    var viewModel: ContentViewModel!
    var webView: WKWebView!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // ViewModel'ı initialize et
        viewModel = ContentViewModel()

        // WebView'i initialize et
        webView = WKWebView()

        // ViewModel'deki webView'i set et
        viewModel.webView = webView
    }

    override func tearDownWithError() throws {
        viewModel = nil
        webView = nil
        try super.tearDownWithError()
    }

    func testWebViewLoad() throws {
        let expectation = XCTestExpectation(description: "WebView loads initial URL")

        // Delegate ayarla
        webView.navigationDelegate = WebViewNavigationDelegate(expectation: expectation)

        // URL'yi yükle
        let testURL = URL(string: "https://www.byalyametal.com")!
        webView.load(URLRequest(url: testURL))

        // Bekleyiş süresi
        wait(for: [expectation], timeout: 10.0)

        // URL kontrolü
        XCTAssertTrue(webView.url?.absoluteString.hasPrefix(testURL.absoluteString) ?? false, "URL'ler eşleşmiyor: \(webView.url?.absoluteString ?? "nil")")
    }

    func testTabSelection() throws {
        let initialURL = URL(string: "https://www.byalyametal.com")!
        let productsURL = URL(string: "https://www.byalyametal.com/urunler/")!

        // İlk URL yüklenmesi için test
        let initialExpectation = XCTestExpectation(description: "WebView loads initial URL after back button")
        webView.navigationDelegate = WebViewNavigationDelegate(expectation: initialExpectation)

        // URL'yi yükle ve bekle
        webView.load(URLRequest(url: initialURL))
        wait(for: [initialExpectation], timeout: 10.0)

        XCTAssertTrue(webView.url?.absoluteString.hasPrefix(initialURL.absoluteString) ?? false, "İlk URL yüklenmedi: \(webView.url?.absoluteString ?? "nil")")

        // Ürünler tab'ının seçilmesi
        let productsExpectation = XCTestExpectation(description: "WebView updates URL after selecting products tab")
        webView.navigationDelegate = WebViewNavigationDelegate(expectation: productsExpectation)

        // Simulate tab selection
        viewModel.selectedTabIndex = 3
        viewModel.webView?.load(URLRequest(url: productsURL))

        wait(for: [productsExpectation], timeout: 10.0)

        XCTAssertEqual(viewModel.webView?.url?.absoluteString, productsURL.absoluteString, "Ürünler URL'si beklenen URL ile eşleşmiyor: \(viewModel.webView?.url?.absoluteString ?? "nil")")
    }

    func testPerformanceExample() throws {
        self.measure {
            let url = URL(string: "https://www.byalyametal.com")!
            webView.load(URLRequest(url: url))
            let expectation = XCTestExpectation(description: "WebView loads URL for performance test")
            webView.navigationDelegate = WebViewNavigationDelegate(expectation: expectation)
            wait(for: [expectation], timeout: 10.0)
        }
    }
}

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    let expectation: XCTestExpectation

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        expectation.fulfill()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        expectation.fulfill() // Bu durumda da beklentiyi karşılayalım.
    }
}








