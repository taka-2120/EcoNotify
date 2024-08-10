//
//  Frequency.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUICore
import EcoNotifyEntity

extension Frequency {
    public var label: LocalizedStringResource {
        switch self {
        case .every: "every"
        case .first: "first"
        case .second: "second"
        case .third: "third"
        case .fourth: "fourth"
        }
    }
}
