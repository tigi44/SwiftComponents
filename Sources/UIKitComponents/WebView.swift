//
//  WebView.swift
//  TheLife-Lotto
//
//  Created by tigi KIM on 2021/06/08.
//

import SwiftUI
import WebKit



// MARK: - WebView


public struct WebView: View {
    let url: String
    let preferredContentMode: WKWebpagePreferences.ContentMode
    
    public init(url: String, preferredContentMode: WKWebpagePreferences.ContentMode = .mobile) {
        self.url = url
        self.preferredContentMode = preferredContentMode
    }
    
    public var body: some View {
        WebKitWebView(url: url,
                      preferredContentMode: preferredContentMode,
                      webViewObject: ObserableWebView())
    }
}


// MARK: - NaviWebView - with web navigation header


public struct NaviWebView: View {
    let url: String
    let preferredContentMode: WKWebpagePreferences.ContentMode
    
    @State private var canGoBack: Bool = false
    @State private var canGoForward: Bool = false
    @StateObject private var webViewObject: ObserableWebView = ObserableWebView()
    
    public init(url: String, preferredContentMode: WKWebpagePreferences.ContentMode = .mobile) {
        self.url = url
        self.preferredContentMode = preferredContentMode
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 20) {
                    Button {
                        webViewObject.webView?.goBack()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .disabled(!(webViewObject.webView?.canGoBack ?? false))
                    
                    Button {
                        webViewObject.webView?.goForward()
                    } label: {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(!(webViewObject.webView?.canGoForward ?? false))
                }
                
                Spacer()
                
                Button {
                    if let url = webViewObject.webView?.url {
                        print(url)
                        UIApplication.shared.open(url,
                                                  options: [:],
                                                  completionHandler: nil)
                    }
                } label: {
                    Image(systemName: "safari")
                }
            }
            .padding()
            .background(.regularMaterial)
            
            WebKitWebView(url: url,
                          preferredContentMode: preferredContentMode,
                          webViewObject: webViewObject)
        }
    }
}


// MARK: - preview


struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: "https://www.apple.com")
        
        NaviWebView(url: "https://www.apple.com")
    }
}


// MARK: - UIWebView : UIViewRepresentable


class ObserableWebView: ObservableObject {
    @Published var webView: WKWebView?
}

struct WebKitWebView: UIViewRepresentable {
    var url: String
    let preferredContentMode: WKWebpagePreferences.ContentMode
    @ObservedObject var webViewObject: ObserableWebView
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let pref = WKWebpagePreferences.init()
        pref.preferredContentMode = preferredContentMode
        configuration.defaultWebpagePreferences = pref
        
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
        
        var parent: WebKitWebView
           
        init(_ parent: WebKitWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView,
                       decidePolicyFor navigationAction: WKNavigationAction,
                       decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.webViewObject.webView = webView
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            webView.load(navigationAction.request)
            
            return nil
        }
    }
}
