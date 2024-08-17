//
//  CircleActionButton.swift
//
//
//  Created by Yu Takahashi on 6/13/24.
//

import SwiftUI

struct CircleActionButton: View {

    @Environment(\.dismiss) private var dismiss
    private let action: (() -> Void)?
    private let symbol: String?

    init(symbol: String? = nil, action: (() -> Void)? = nil) {
        self.symbol = symbol
        self.action = action
    }

    var body: some View {
        Button {
            if let action = action {
                action()
            } else {
                dismiss()
            }
        } label: {
            CircleActionContent(symbol: symbol)
        }
    }
}
