//
//  CircleActionContent.swift
//
//
//  Created by Yu Takahashi on 6/13/24.
//

import SwiftUI

struct CircleActionContent: View {
    @Environment(\.colorScheme) private var colorScheme
    private let symbol: String?

    init(symbol: String? = nil) {
        self.symbol = symbol
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
            Image(systemName: symbol ?? "xmark")
                .resizable()
                .scaledToFit()
                .font(.body)
                .fontWeight(.bold)
                .scaleEffect(0.416)
                .foregroundStyle(Color(white: colorScheme == .dark ? 0.62 : 0.51))
        }
        .frame(width: 30, height: 30)
    }
}
