//
//  ContentView.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUI
import SwiftData
import WidgetKit
import EcoNotifyEntity
import EcoNotifyCore
import ActivityKit


public struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Trash.next) private var trashes: [Trash]
    
    @State private var isAddSheetShown = false
    @State private var nextCollection: Trash? = nil
    
    public init() {}

    public var body: some View {
        NavigationStack {
            Group {
                if trashes.isEmpty {
                    VStack {
                        Text("empty_collection")
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.center)
                    }
                } else {
                    List {
                        if let nextCollection = nextCollection {
                            Section {
                                VStack(alignment: .leading) {
                                    Text("next_collection")
                                        .font(.title2)
                                        .bold()
                                    HStack(alignment: .center) {
                                        Image(nextCollection.category.image)
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                        Text(nextCollection.name)
                                            .font(.title3)
                                        Spacer()
                                        Text(nextCollection.next.relativeLabel())
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    if nextCollection.next.isToday {
                                        Button {
                                            nextCollection.setNext()
                                        } label: {
                                            HStack {
                                                Spacer()
                                                Text("took_out")
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal, 50)
                                                    .background(Color.accentColor)
                                                    .foregroundStyle(.white)
                                                    .corner()
                                                Spacer()
                                            }
                                        }
                                        .buttonStyle(.borderless)
                                    } else {
                                        Spacer(minLength: 30)
                                    }
                                }
                                .padding(.top, 5)
                                .overlay(alignment: .bottomTrailing) {
                                    Button {
                                        nextCollection.setNext()
                                    } label: {
                                        Text("skip")
                                            .padding(10)
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                        
                        ForEach(trashes, id: \.id) { trash in
                            TrashItem(for: trash)
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .sheet(isPresented: $isAddSheetShown) {
                Task { @MainActor in
                    updateNext()
                }
            } content: {
                DetailsView()
            }
            .refreshable {
                Task { @MainActor in
                    updateNext()
                }
            }
            .onAppear {
                updateNext()
                Task { @MainActor in
                    do {
                        try await NotificationManager.request()
                    } catch {
                        print(error)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("add", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("title")
        }
    }

    private func addItem() {
        isAddSheetShown.toggle()
    }
    
    private func updateNext() {
        for trash in trashes {
            if trash.next < Date() {
                trash.next = Date()
            }
        }
        
        guard let nextCollection = getNext() else {
            return
        }
        self.nextCollection = nextCollection
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func getNext() -> Trash? {
        var next: Trash? = nil
        for trash in trashes {
            if next == nil || next!.next > trash.next {
                next = trash
            }
        }
        return next
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(trashes[index])
                NotificationManager.cancelNotification(for: "\(trashes[index].id)")
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Trash.self, CollectionDate.self], inMemory: true)
}
