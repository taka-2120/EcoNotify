//
//  EcoNotifyApp.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUI
import SwiftData
import EcoNotifyEntity
import EcoNotifyFeature

@main
struct EcoNotifyApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
