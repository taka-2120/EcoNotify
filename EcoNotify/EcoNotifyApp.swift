//
//  EcoNotifyApp.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUI
import SwiftData
import WhatsNewKit
import EcoNotifyEntity
import EcoNotifyFeature

@main
struct EcoNotifyApp: App {
    @AppStorage(Constant.UserDefaultsKey.isFirstLaunched.rawValue)
    private var isFirstLaunched: Bool = false
    
    @UIApplicationDelegateAdaptor
    private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isFirstLaunched {
                    ContentView()
                } else {
                    WelcomeView()
                }
            }
            .animation(.easeInOut, value: isFirstLaunched)
            .whatsNewSheet(layout: .default)
            .environment(
                \.whatsNew,
                 WhatsNewEnvironment(
                    versionStore: UserDefaultsWhatsNewVersionStore(),
                    whatsNewCollection: self
                 )
            )
        }
        .modelContainer(sharedModelContainer)
    }
}
