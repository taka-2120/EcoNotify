//
//  View+CornerRadius.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUI

extension View {
    public func corner(radius: CGFloat = 15) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius))
    }
}
