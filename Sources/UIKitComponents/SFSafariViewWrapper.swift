//
//  SFSafariViewWrapper.swift
//  
//
//  Created by tigi KIM on 2022/01/08.
//

import SwiftUI
import SafariServices

public struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}


// MARK: - preview


struct SFSafariViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        SFSafariViewWrapper(url: URL(string: "https://www.apple.com")!)
            .edgesIgnoringSafeArea(.all)
    }
}
