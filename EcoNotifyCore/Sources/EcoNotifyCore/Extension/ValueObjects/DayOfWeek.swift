//
//  DayOfWeek.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUICore
import EcoNotifyEntity

extension DayOfWeek {
    public var label: LocalizedStringResource {
        switch self {
        case .sunday: "sunday"
        case .monday: "monday"
        case .tuesday: "tuesday"
        case .wednesday: "wednesday"
        case .thursday: "thursday"
        case .friday: "friday"
        case .saturday: "saturday"
        }
    }
}
