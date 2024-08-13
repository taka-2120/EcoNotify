//
//  LoadingView.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/13/24.
//

import SwiftUI
import EcoNotifyCore

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image.appIcon
                .resizable()
                .frame(width: 200, height: 200)
                .corner(radius: 25)
                .shadow(color: .black.opacity(0.02), radius: 15, y: 3)
            Text("widget_description")
                .font(.title3)
            Spacer()
            ProgressView()
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    LoadingView()
}
