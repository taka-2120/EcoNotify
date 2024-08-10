//
//  NotifyBefore.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUICore

public enum NotifyBefore: Int, CaseIterable, Codable {
    case none = -1
    case onTheDay = 0
    case oneDayBefore = 1
    case twoDaysBefore = 2
    case threeDaysBefore = 3
}
