//
//  UserDefaults.swift
//  SwiftComponents
//
//  Created by tigi KIM on 12/5/25.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
    let key: String
    let defaultValue: T

    public var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
