//
//  WebView.swift
//  TheLife-Lotto
//
//  Created by tigi KIM on 2021/06/08.
//

import SwiftUI
import WebKit

public struct WebView: View {
    let url: String
    
    public var body: some View {
        UIWebView(url: url)
    }
}

struct UIWebView: UIViewRepresentable {
    var url: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
    }
    
    class Coordinator : NSObject, WKNavigationDelegate, WKUIDelegate {
        
        var parent: UIWebView
           
        init(_ parent: UIWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView,
                       decidePolicyFor navigationAction: WKNavigationAction,
                       decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            decisionHandler(.allow)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: "https://www.apple.com")
    }
}
