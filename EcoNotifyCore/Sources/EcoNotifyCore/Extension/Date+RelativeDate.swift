//
//  Date+RelativeDate.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/15/24.
//

import SwiftUICore

extension Date {
    public func relativeLabel(localized: Bool = true) -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
            
        let todayString = dateFormatter.string(from: today)
        let dateToCheckString = dateFormatter.string(from: self)
            
        guard let todayFormatted = dateFormatter.date(from: todayString),
              let dateToCheckFormatted = dateFormatter.date(from: dateToCheckString) else {
            return self.toString(date: .medium, time: .none)
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: todayFormatted, to: dateToCheckFormatted)
        
        if let difference = components.day {
            if difference == 0 {
                return localized ? String(localized: "today") : "today"
            } else if difference == 1 {
                return localized ? String(localized: "tomorrow") : "tomorrow"
            }
        }
        return self.toString(date: .medium, time: .none)
    }
    
    public var isToday: Bool {
        return self.relativeLabel(localized: false) == "today"
    }
}
