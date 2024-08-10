//
//  AppIntent.swift
//  EcoNotifyWidget
//
//  Created by Yu Takahashi on 7/18/24.
//

import WidgetKit
import AppIntents
import SwiftData
import EcoNotifyEntity

struct TrashAppIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Notify Collection"
    static let description: IntentDescription = "This widget notify you on the day your garbage collection."
    
    @Parameter(title: "Trash")
    private var trashName: String?
    
    init() {
        trashName = ""
    }
    
    init(for trashName: String) {
        self.trashName = trashName
    }
    
    @MainActor
    func perform() throws -> some IntentResult {
        guard let trashName = trashName else {
            return .result()
        }
        var descriptor = FetchDescriptor<Trash>(predicate: #Predicate { $0.name == trashName} )
        descriptor.fetchLimit = 1
        let trash = try sharedModelContainer.mainContext.fetch(descriptor)
        
        guard let trash = trash.first else {
            return .result()
        }
        trash.setNext()
        return .result()
    }
}
