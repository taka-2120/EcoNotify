//
//  NotifyBefore.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUICore
import EcoNotifyEntity

extension NotifyBefore {
    public var label: LocalizedStringResource {
        switch self {
        case .none: "none"
        case .onTheDay: "onTheDay"
        case .oneDayBefore: "oneDayBefore"
        case .twoDaysBefore: "twoDaysBefore"
        case .threeDaysBefore: "threeDaysBefore"
        }
    }
    
    public var relativeLabel: LocalizedStringResource {
        switch self {
        case .onTheDay: "today"
        case .oneDayBefore: "tomorrow"
        case .twoDaysBefore: "twoDaysLater"
        case .threeDaysBefore: "threeDaysLater"
        default: ""
        }
    }
}
