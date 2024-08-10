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
import ActivityKit

struct TrashAppIntent: WidgetConfigurationIntent, LiveActivityIntent {
    static let title: LocalizedStringResource = "Notify Collection"
    static let description: IntentDescription = "This widget notify you on the day your garbage collection."
    
    @Parameter(title: "Trash")
    private var trashName: String?
    @Parameter(title: "Id")
    private var id: String?
    private var isInvalid: Bool {
        trashName == nil || trashName?.isEmpty ?? true || id == nil || id?.isEmpty ?? true
    }
    
    init() {
        id = ""
        trashName = ""
    }
    
    init(_ id: String, for trashName: String) {
        self.id = id
        self.trashName = trashName
    }
    
    @MainActor func perform() throws -> some IntentResult {
        var descriptor = FetchDescriptor<Trash>(predicate: #Predicate { $0.name == trashName!} )
        descriptor.fetchLimit = 1
        let trash = try sharedModelContainer.mainContext.fetch(descriptor)
        
        guard let trash = trash.first, let id = id else {
            return .result()
        }
        trash.setNext()
        
        Task { @MainActor in
            await ActivityManager.endActivity(for: id)
        }
        return .result()
    }
}

private enum Status: Error {
    case end
}
