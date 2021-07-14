//
//  ViewModifier.swift
//  TheLife-Lotto
//
//  Created by tigi KIM on 2021/06/18.
//

import SwiftUI

public struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}

public struct ScrollViewOffsetModifier: ViewModifier {
    
    public enum Anchor {
        case top, leading, bottom, trailing
    }
    
    var anchorPoint: Anchor = .top
    @Binding var offset: CGFloat
    
    public init(anchorPoint: Anchor = .top, offset: Binding<CGFloat>) {
        self.anchorPoint = anchorPoint
        self._offset = offset
    }
    
    public func body(content: Content) -> some View {
        
        content
            .overlay(
            
                GeometryReader { proxy -> Color in
                
                    let frame = proxy.frame(in: .global)
                
                    DispatchQueue.main.async {
                        
                        switch anchorPoint {
                        case .top:
                            offset = frame.minY
                        case .leading:
                            offset = frame.minX
                        case .bottom:
                            offset = frame.maxY
                        case .trailing:
                            offset = frame.maxX
                        }
                    }
                    return .clear
                }
            )
    }
}
