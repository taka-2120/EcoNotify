//
//  EcoNotifyWidget.swift
//  EcoNotifyWidget
//
//  Created by Yu Takahashi on 7/18/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import EcoNotifyEntity
import EcoNotifyCore

struct Provider: AppIntentTimelineProvider {
    private let modelContext: ModelContext
    
    init(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func placeholder(in context: Context) -> TrashEntry {
        TrashEntry(date: Date(), nextTrash: Trash("burnable", category: .burnable, nextFrom: Date(), collectOn: [.init(on: .every, .monday)], notifyOn: .oneDayBefore, at: Date(), comment: "", url: ""))
    }
    
    func snapshot(for configuration: TrashAppIntent, in context: Context) async -> TrashEntry {
        TrashEntry(date: Date(), nextTrash: getNextTrash())
    }
    
    func timeline(for configuration: TrashAppIntent, in context: Context) async -> Timeline<TrashEntry> {
        let timeline = Timeline(
            entries: [TrashEntry(date: .now, nextTrash: getNextTrash())],
            policy: .after(.now.advanced(by: 60 * 60 * 12))
        )
        
        return timeline
    }
    
    // TODO: For support watchOS
    func recommendations() -> [AppIntentRecommendation<TrashAppIntent>] {
        return []
    }
    
    private func getNextTrash() -> Trash? {
        let descriptor = FetchDescriptor<Trash>(sortBy: [.init(\.next)])
        let trashes = try? modelContext.fetch(descriptor)
        return trashes?.first
    }
}

struct TrashEntry: TimelineEntry {
    let date: Date
    let nextTrash: Trash?
}

struct EcoNotifyWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily

    var entry: Provider.Entry

    var body: some View {
        Group {
            if let trash = entry.nextTrash {
                VStack(alignment: .leading) {
                    HStack {
                        Image(trash.category.image)
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        #if !os(watchOS)
                        if widgetFamily != .systemSmall {
                            Text(trash.name)
                                .font(.title3)
                                .bold()
                        }
                        #endif
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(trash.next.relativeLabel())
                                .foregroundStyle(.secondary)
                                .font(.caption)
                                .lineLimit(1)
                                .multilineTextAlignment(.trailing)
                                .minimumScaleFactor(0.1)
                            
                            #if !os(watchOS)
                            if trash.next.isToday && widgetFamily == .systemSmall {
                                Button(intent: TrashAppIntent(for: trash.name)) {
                                    Text("skip")
                                        .font(.caption)
                                }
                                .foregroundStyle(.primary)
                                .foregroundStyle(Color(.label))
                                .background(.clear)
                            }
                            #endif
                            Spacer()
                        }
                    }
                    
                    #if !os(watchOS)
                    if widgetFamily == .systemSmall {
                        Text(trash.name)
                            .bold()
                    }
                    #endif
                    
                    if trash.next.isToday {
                        HStack {
                            Button(intent: TrashAppIntent(for: trash.name)) {
                                HStack {
                                    Spacer()
                                    Text("took_out")
                                        .font(.callout)
                                    Spacer()
                                }
                            }
                            .background(.accent)
                            .foregroundStyle(.white)
                            .corner()
                            #if !os(watchOS)
                            if widgetFamily != .systemSmall {
                                Button(intent: TrashAppIntent(for: trash.name)) {
                                    Text("skip")
                                        .font(.callout)
                                }
                                .background(.clear)
                            }
                            #endif
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button(intent: TrashAppIntent(for: trash.name)) {
                                Text("skip")
                                    .font(.callout)
                            }
                            #if os(watchOS)
                            .foregroundStyle(.primary)
                            #else
                            .foregroundStyle(Color(.label))
                            #endif
                            .background(.clear)
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            } else {
                VStack {
                    Text("widget_empty_collection")
                }
            }
        }
    }
}

struct EcoNotifyWidget: Widget {
    private let kind: String = "EcoNotifyWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: TrashAppIntent.self,
            provider: Provider(sharedModelContainer.mainContext)
        ) { entry in
            EcoNotifyWidgetEntryView(entry: entry)
                .containerBackground(.regularMaterial, for: .widget)
                .modelContainer(sharedModelContainer)
        }
        .configurationDisplayName("widget_title")
        .description("widget_description")
        #if os(watchOS)
        .supportedFamilies([.accessoryRectangular])
        #else
        .supportedFamilies([.systemSmall, .systemMedium])
        #endif
    }
}

#Preview(as: .accessoryRectangular) {
    EcoNotifyWidget()
} timeline: {
    TrashEntry(date: .now, nextTrash: nil)
}
