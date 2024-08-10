//
//  SDContainer.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 7/20/24.
//

import SwiftData

public let sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Trash.self,
        CollectionDate.self,
    ])
    let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false,
        allowsSave: true,
        groupContainer: .automatic
    )

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
