//
//  DateExtension.swift
//  TheLife-Lotto
//
//  Created by tigi KIM on 2021/05/14.
//

import Foundation

public extension Date {
    func toString(_ dateFormat: String = "yyyy. MM. dd.") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
