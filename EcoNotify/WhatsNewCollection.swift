//
//  WhatsNewCollection.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 8/17/24.
//

import WhatsNewKit

extension EcoNotifyApp: WhatsNewCollectionProvider {
    
    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(
            version: "1.0.0",
            title: .init(stringLiteral: String(localized: "whats_new_title")),
            features: [
                .init(
                    image: .init(
                        systemName: "bell",
                        foregroundColor: .red
                    ),
                    title: .init(String(localized: "whats_new_notification_title")),
                    subtitle: .init(String(localized: "notification_description"))
                ),
                .init(
                    image: .init(
                        systemName: "widget.medium",
                        foregroundColor: .blue
                    ),
                    title: .init(String(localized: "whats_new_widget_title")),
                    subtitle: .init(
                        String(localized: "You can check the collection date just a glance at your Home Screen.")
                    )
                ),
                .init(
                    image: .init(
                        systemName: "link",
                        foregroundColor: .gray
                    ),
                    title: .init(String(localized: "whats_new_link_title")),
                    subtitle: .init(String(localized: "whats_new_link_description"))
                ),
            ],
            primaryAction: .init(
                hapticFeedback: {
                    #if os(iOS)
                    .notification(.success)
                    #else
                    nil
                    #endif
                }()
            )
        )
    }

}
