//
//  StringExtension.swift
//  
//
//  Created by tigi KIM on 2022/01/08.
//

import Foundation

public extension String {
    func toDate(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss", timeZone: String = "UTC") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone(name: timeZone) as TimeZone?
        return dateFormatter.date(from: self)
    }
}
