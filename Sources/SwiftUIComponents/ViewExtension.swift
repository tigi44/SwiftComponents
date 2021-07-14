//
//  ViewExtension.swift
//  TheLife-Lotto
//
//  Created by tigi KIM on 2021/05/18.
//

import SwiftUI
import UIKitComponents

public extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide { hidden() }
        else { self }
    }
}

public extension View {
    func gradientForeground(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: startPoint,
                                    endPoint: endPoint))
            .mask(self)
    }
}

public extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}

public extension View {
    @available(iOS 15, *)
    func sheetPresentation<SheetView: View>(isPresented: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView, onDismiss: SheetPresentationController<SheetView>.DefaultClosureType? = nil) -> some View {
        self.background(
            SheetPresentationController(isPresented: isPresented, sheetView: sheetView(), onDismiss: onDismiss)
        )
    }
}

public extension Alert {
    init(errorMessage: String?) {
        
        var message: String = "잠시후 다시 시도해주세요."
        
        if let errorMessage = errorMessage {
            message = errorMessage
        }
        
        self = Alert(title: Text("Error"), message: Text(message), dismissButton: nil)
    }
}

extension Alert: Identifiable {
    public var id: String {
        UUID().uuidString
    }
}

extension ActionSheet: Identifiable {
    public var id: String {
        UUID().uuidString
    }
}
