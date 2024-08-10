//
//  EcoNotifyActivityLiveActivity.swift
//  EcoNotifyActivity
//
//  Created by Yu Takahashi on 7/21/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import EcoNotifyEntity

struct EcoNotifyLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: EcoNotifyActivityAttributes.self) { context in
            HStack {
                Circle()
                    .fill(Color(hex: context.attributes.colorCode))
                    .frame(width: 20, height: 20)
                VStack {
                    Text(context.attributes.name)
                        .bold()
                        .font(.title3)
                        .minimumScaleFactor(0.1)
                }
                
                Spacer()
                
                Button(intent: TrashAppIntent(context.activityID, for: context.attributes.name)) {
                    Text("took_out")
                        .font(.callout)
                }
                .tint(.accent)
                
                Button(intent: TrashAppIntent(context.activityID, for: context.attributes.name)) {
                    Text("skip")
                        .font(.callout)
                }
            }
            .padding()
            .activityBackgroundTint(Color(.systemBackground))
            .activitySystemActionForegroundColor(Color(.label))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Circle()
                            .fill(Color(hex: context.attributes.colorCode))
                            .frame(width: 20, height: 20)
                        Spacer()
                        Text(context.attributes.name)
                            .bold()
                            .font(.title3)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Button(intent: TrashAppIntent(context.activityID, for: context.attributes.name)) {
                        Text("skip")
                            .font(.callout)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Button(intent: TrashAppIntent(context.activityID, for: context.attributes.name)) {
                        HStack {
                            Spacer()
                            Text("took_out")
                            Spacer()
                        }
                    }
                    .tint(.accent)
                }
            } compactLeading: {
                Circle()
                    .fill(Color(hex: context.attributes.colorCode))
                    .frame(width: 20, height: 20)
            } compactTrailing: {
                Text(context.attributes.name)
                    .foregroundStyle(.green)
                    .font(.callout)
            } minimal: {
                Circle()
                    .fill(Color(hex: context.attributes.colorCode))
                    .frame(width: 20, height: 20)
            }
            .keylineTint(Color.green)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension EcoNotifyActivityAttributes {
    fileprivate static var preview: EcoNotifyActivityAttributes {
        EcoNotifyActivityAttributes(name: "Preview", color: "#000000")
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


#Preview("Notification", as: .content, using: EcoNotifyActivityAttributes.preview) {
    EcoNotifyLiveActivity()
} contentStates: {
    EcoNotifyActivityAttributes.ContentState()
}
