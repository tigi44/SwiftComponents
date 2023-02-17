//
//  ScrollViewOffsetModifier.swift
//  
//
//  Created by tigi KIM on 2023/02/17.
//

import SwiftUI

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
