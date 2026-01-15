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
    let isInspectable: Bool
    
    public init(url: String, preferredContentMode: WKWebpagePreferences.ContentMode = .mobile) {
        self.url = url
        self.preferredContentMode = preferredContentMode
        self.isInspectable = false
    }
    
    @available(iOS 16.4, *)
    public init(url: String, preferredContentMode: WKWebpagePreferences.ContentMode = .mobile, isInspectable: Bool = false) {
        self.url = url
        self.preferredContentMode = preferredContentMode
        self.isInspectable = isInspectable
    }
    
    public var body: some View {
        WebKitWebView(url: url,
                      preferredContentMode: preferredContentMode,
                      isInspectable: isInspectable,
                      webViewObject: ObserableWebView())
    }
}


// MARK: - NaviWebView - with web navigation header


public struct NaviWebView: View {
    let url: String
    let preferredContentMode: WKWebpagePreferences.ContentMode
    let isInspectable: Bool
    
    @State private var canGoBack: Bool = false
    @State private var canGoForward: Bool = false
    @StateObject private var webViewObject: ObserableWebView = ObserableWebView()
    
    public init(url: String, preferredContentMode: WKWebpagePreferences.ContentMode = .mobile) {
        self.url = url
        self.preferredContentMode = preferredContentMode
        self.isInspectable = false
    }
    
    @available(iOS 16.4, *)
    public init(url: String, preferredContentMode: WKWebpagePreferences.ContentMode = .mobile, isInspectable: Bool = false) {
        self.url = url
        self.preferredContentMode = preferredContentMode
        self.isInspectable = isInspectable
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
                          isInspectable: isInspectable,
                          webViewObject: webViewObject)
        }
    }
}


// MARK: - NaviSheetWebView - with web navigation header


public struct NaviSheetWebView: View {
    @Environment(\.dismiss) private var dismiss
    
    let url: String
    let preferredContentMode: WKWebpagePreferences.ContentMode
    let isInspectable: Bool
    
    @State private var canGoBack: Bool = false
    @State private var canGoForward: Bool = false
    @StateObject private var webViewObject: ObserableWebView = ObserableWebView()
    
    public init(url: String, preferredContentMode: WKWebpagePreferences.ContentMode = .mobile) {
        self.url = url
        self.preferredContentMode = preferredContentMode
        self.isInspectable = false
    }
    
    @available(iOS 16.4, *)
    public init(url: String, preferredContentMode: WKWebpagePreferences.ContentMode = .mobile, isInspectable: Bool = false) {
        self.url = url
        self.preferredContentMode = preferredContentMode
        self.isInspectable = isInspectable
    }
    
    public var body: some View {
        NavigationView {
            WebKitWebView(url: url,
                          preferredContentMode: preferredContentMode,
                          isInspectable: isInspectable,
                          webViewObject: webViewObject)
            .toolbar {
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                        })
                    }
                    
                    ToolbarSpacer(.fixed, placement: .topBarLeading)
                    
                    if webViewObject.webView?.canGoBack ?? false {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                webViewObject.webView?.goBack()
                            } label: {
                                Image(systemName: "chevron.backward")
                            }
                        }
                    }
                    
                    if webViewObject.webView?.canGoForward ?? false {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                webViewObject.webView?.goForward()
                            } label: {
                                Image(systemName: "chevron.forward")
                            }
                        }
                    }
                } else {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                        })
                        
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
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        if let url = webViewObject.webView?.url {
                            UIApplication.shared.open(url,
                                                      options: [:],
                                                      completionHandler: nil)
                        }
                    }, label: {
                        Image(systemName: "safari")
                    })
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}


// MARK: - preview


struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: "https://www.apple.com")
            .previewDisplayName("WebView")
        
        NaviWebView(url: "https://www.apple.com")
            .previewDisplayName("NaviWebView")
        
        NaviSheetWebView(url: "https://www.apple.com")
            .previewDisplayName("NaviPopupWebView")
    }
}


// MARK: - UIWebView : UIViewRepresentable

private let windowOpenOverrideJS = """
(function() {
  if (window.__popupIntercepted__) { return; }
  window.__popupIntercepted__ = true;

  const originalOpen = window.open;
  window.open = function(url, name, specs) {
    if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.windowOpen) {
      window.webkit.messageHandlers.windowOpen.postMessage({
        url: url,
        name: name || null,
        specs: specs || null
      });
      return null;
    }
    return originalOpen.apply(window, arguments);
  };
})();
"""

class ObserableWebView: ObservableObject {
    @Published var webView: WKWebView?
}

struct WebKitWebView: UIViewRepresentable {
    let url: String
    let preferredContentMode: WKWebpagePreferences.ContentMode
    let isInspectable: Bool
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
        
        let contentController = WKUserContentController()
        let script = WKUserScript(
            source: windowOpenOverrideJS,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        
        contentController.addUserScript(script)
        contentController.add(context.coordinator, name: "windowOpen")

        configuration.userContentController = contentController
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        if #available(iOS 16.4, *) {
            webView.isInspectable = isInspectable
        }
        
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
    }
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        coordinator.cleanupPendingJSDialogs()
        uiView.stopLoading()
        uiView.uiDelegate = nil
        uiView.navigationDelegate = nil
    }
    
    class Coordinator : NSObject {
        enum JSDialog {
            case alert(() -> Void)
            case confirm((Bool) -> Void)
            case prompt((String?) -> Void)
        }
        
        private var pendingDialog: JSDialog?
        private var parent: WebKitWebView
           
        init(_ parent: WebKitWebView) {
            self.parent = parent
        }
        
        func cleanupPendingJSDialogs() {
            switch pendingDialog {
            case .alert(let handler):
                handler()
            case .confirm(let handler):
                handler(false)
            case .prompt(let handler):
                handler(nil)
            case .none:
                break
            }
            pendingDialog = nil
        }
    }
}

extension WebKitWebView.Coordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                   decidePolicyFor navigationAction: WKNavigationAction,
                   decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            webView.load(URLRequest(url: url))
            decisionHandler(.cancel)
            
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        parent.webViewObject.webView = webView
    }
}

extension WebKitWebView.Coordinator: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        
        return nil
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void
    ) {
        pendingDialog = .alert(completionHandler)
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: nil, style: .default) { [weak self] _ in
            completionHandler()
            self?.pendingDialog = nil
        })
        
        UIApplication.shared.topViewController()?.present(alert, animated: true)
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void
    ) {
        pendingDialog = .confirm(completionHandler)
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: nil, style: .cancel) { [weak self] _ in
            completionHandler(false)
            self?.pendingDialog = nil
        })
        
        alert.addAction(UIAlertAction(title: nil, style: .default) { [weak self] _ in
            completionHandler(true)
            self?.pendingDialog = nil
        })
        
        UIApplication.shared.topViewController()?.present(alert, animated: true)
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void
    ) {
        pendingDialog = .prompt(completionHandler)
        
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alert.addTextField { $0.text = defaultText }
        
        alert.addAction(UIAlertAction(title: nil, style: .cancel) { [weak self] _ in
            completionHandler(nil)
            self?.pendingDialog = nil
        })
        
        alert.addAction(UIAlertAction(title: nil, style: .default) { [weak self] _ in
            completionHandler(alert.textFields?.first?.text)
            self?.pendingDialog = nil
        })
        
        UIApplication.shared.topViewController()?.present(alert, animated: true)
    }
}

extension WebKitWebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            message.name == "windowOpen",
            let body = message.body as? [String: Any],
            let urlString = body["url"] as? String,
            let url = URL(string: urlString)
        else { return }

        if let webView = message.webView {
            webView.load(URLRequest(url: url))
        }
    }
}

fileprivate extension UIApplication {
    func topViewController(
        base: UIViewController? = nil
    ) -> UIViewController? {
        
        let baseVC: UIViewController?
        
        if let base = base {
            baseVC = base
        } else {
            baseVC = connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .rootViewController
        }
        
        if let nav = baseVC as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = baseVC as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        
        if let presented = baseVC?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return baseVC
    }
}
