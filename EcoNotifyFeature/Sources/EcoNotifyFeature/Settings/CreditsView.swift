//
//  CreditsView.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/15/24.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        List {
            flaticonLink(for: "fire")
            flaticonLink(for: "waste")
            flaticonLink(for: "water bottle")
            flaticonLink(for: "box")
            flaticonLink(for: "soda")
            flaticonLink(for: "wine bottle")
            flaticonLink(for: "news")
            flaticonLink(for: "magazine")
            flaticonLink(for: "tweet")
            flaticonLink(for: "github")
        }
        .navigationTitle("credits")
    }
    
    private func flaticonLink(for title: String) -> some View {
        Link(
            "\(title.capitalized) icons created by Freepik - Flaticon",
            destination: URL(
                string: "https://www.flaticon.com/free-icons/\(title.lowercased().replacingOccurrences(of: " ", with: "-"))"
            )!
        )
    }
}

#Preview {
    CreditsView()
}
