//
//  BindingExtension.swift
//  TheLife-Lotto
//
//  Created by tigi KIM on 2021/05/14.
//

import SwiftUI

public extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
