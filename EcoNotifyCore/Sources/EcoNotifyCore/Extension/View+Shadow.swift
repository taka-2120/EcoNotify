//
//  View+Shadow.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 8/17/24.
//

import SwiftUI

extension View {
    public func shadow() -> some View {
        self.shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 3)
    }
}
