//
//  Date+Format.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/15/24.
//

import Foundation

extension Date {
    public func toString(date: DateFormatter.Style = .medium, time: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = date
        dateFormatter.timeStyle = time
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: Locale.current.language.languageCode?.identifier ?? "en-US")
        
        return dateFormatter.string(from: self)
    }
}
