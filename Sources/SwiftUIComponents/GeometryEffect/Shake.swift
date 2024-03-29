//
//  Shake.swift
//  
//
//  Created by tigi KIM on 2023/02/17.
//

import SwiftUI
import Combine

public struct Shake: GeometryEffect {
    public enum Axis: String {
        case X, Y
    }
    
    public var axis             : Axis
    public var amount           : CGFloat
    public var shakesPerUnit    : CGFloat
    public var animatableData   : CGFloat
    
    public init(axis: Axis = Axis.X, amount: CGFloat = 10, shakesPerUnit: CGFloat = 4, animatableData: CGFloat) {
        self.axis = axis
        self.amount = amount
        self.shakesPerUnit = shakesPerUnit
        self.animatableData = animatableData
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        switch axis {
        case .X:
            return ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * shakesPerUnit),
                                                         y: 0))
        case .Y:
            return ProjectionTransform(CGAffineTransform(translationX: 0,
                                                         y: amount * sin(animatableData * .pi * shakesPerUnit)))
        }
    }
}


// MARK: - preview


struct ShakeX_Previews: PreviewProvider {
    static var previews: some View {
        TestShakeView(axis: .X)
    }
}

struct ShakeY_Previews: PreviewProvider {
    static var previews: some View {
        TestShakeView(axis: .Y)
    }
}

private struct TestShakeView: View {
    var axis                    : Shake.Axis    = .X
    @State var shakeAttempts    : Int           = 0
    let timer                                   = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text("Shake \(axis.rawValue) axis")
            .onReceive(timer) { _ in
                withAnimation {
                    shakeAttempts += 1
                }
            }
            .modifier(Shake(axis: axis, animatableData: CGFloat(shakeAttempts)))
    }
}
