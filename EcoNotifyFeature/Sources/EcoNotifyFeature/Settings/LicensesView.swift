//
//  LicensesView.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/15/24.
//

import SwiftUI
import EcoNotifyEntity
import EcoNotifyCore

struct LicensesView: View {
    var body: some View {
        List {
            ForEach(Licenses.allCases, id: \.self) { license in
                NavigationLink {
                    ScrollView {
                        Text(license.data)
                            .font(.callout)
                            .foregroundStyle(Color(.secondaryLabel))
                            .padding()
                    }
                    .navigationTitle(license.rawValue)
                } label: {
                    Text(license.rawValue)
                }
            }
        }
        .navigationTitle("licenses")
    }
}

#Preview {
    LicensesView()
}
