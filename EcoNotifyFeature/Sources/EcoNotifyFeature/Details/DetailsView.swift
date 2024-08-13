//
//  DetailsView.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/15/24.
//

import SwiftUI
import SwiftData
import WidgetKit
import EcoNotifyEntity
import EcoNotifyCore

private enum DetailMode {
    case add
    case edit
}

struct DetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var trashes: [Trash]
    @State private var nativeAdViewModel = NativeAdViewModel.shared
    @State private var category: TrashCategory = .burnable
    @State private var name = ""
    @State private var collectionDates = [CollectionDate]()
    private var isAddDisabled: Bool {
        collectionDates.count >= 5
    }
    @State private var notifyDay: NotifyBefore = .none
    @State private var notifyTime = Date()
    @State private var comment = ""
    @State private var url = ""
    @State private var isNotificationErrorOccurred = false
    @State private var nameError: String?
    @State private var isNameErrorShown = false
    @State private var dateError: String?
    @State private var isDateErrorShown = false
    
    private let mode: DetailMode
    private let trash: Trash?
    
    init(for trash: Trash) {
        self.mode = .edit
        self.trash = trash
    }
    
    init() {
        self.mode = .add
        self.trash = nil
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("category", selection: $category) {
                        ForEach(TrashCategory.allCases, id: \.self) { category in
                            Text(String(localized: category.label))
                            .tag(category)
                        }
                    }
                    HStack {
                        Text("name")
                        TextField(String(localized: category.label), text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                } footer: {
                    if let nameError = nameError {
                        Text(nameError)
                            .foregroundStyle(.red)
                    }
                }
                
                NativeAdView(using: nativeAdViewModel)
                    .frame(height: 160)
                    .listRowInsets(EdgeInsets())
                
                Section("collection_dates") {
                    ForEach(Array(collectionDates.enumerated()), id: \.offset) { index, date in
                        HStack {
                            Text(String(index + 1))
                                .padding(8)
                                .bold()
                                .font(.system(size: 13))
                                .foregroundStyle(.white)
                                .background(.black)
                                .clipShape(Circle())
                                .corner(radius: 100)
                            Picker("", selection: $collectionDates[index].frequency) {
                                ForEach(Frequency.allCases, id: \.self) { frequency in
                                    Text(String(localized: frequency.label))
                                        .tag(frequency)
                                }
                            }
                            Spacer()
                            Picker("", selection: $collectionDates[index].dayOfWeek) {
                                ForEach(DayOfWeek.allCases, id: \.self) { dow in
                                    Text(String(localized: dow.label))
                                        .tag(dow)
                                }
                            }
                            Spacer()
                        }
                        .onChange(of: date.dayOfWeek) {
                            collectionDates = collectionDates.sort()
                        }
                    }
                    .onDelete(perform: deleteDates)
                    
                    Button {
                        collectionDates.append(.init(on: .every, .sunday))
                    } label: {
                        Label("add_date", systemImage: "plus.circle.fill")
                    }
                    .foregroundStyle(isAddDisabled ? .gray : .accentColor)
                    .disabled(isAddDisabled)
                }
                
                Section("notification") {
                    Picker("notify_me", selection: $notifyDay) {
                        ForEach(NotifyBefore.allCases, id: \.self) { day in
                            Text(String(localized: day.label))
                                .tag(day)
                        }
                    }
                    if notifyDay != .none {
                        DatePicker("at", selection: $notifyTime, displayedComponents: .hourAndMinute)
                            .padding(.vertical, 5)
                    }
                }
                .animation(.easeInOut, value: notifyDay)
                
                Section("information") {
                    TextField("comment", text: $comment)
                        .lineLimit(5, reservesSpace: true)
                    HStack {
                        Text("URL")
                        TextField("URL", text: $url)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                NativeAdView(using: nativeAdViewModel)
                    .frame(height: 160)
                    .listRowInsets(EdgeInsets())
            }
            .navigationTitle(mode == .add ? "add_title" : "edit_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(mode == .add ? "add" : "save") {
                        checkDuplication(for: name.isEmpty ? String(localized: category.label) : name)
                        if nameError != nil {
                            isNameErrorShown.toggle()
                            return
                        }
                        if collectionDates.isEmpty {
                            dateError = String(localized: "error_no_collection_date")
                            isDateErrorShown.toggle()
                            return
                        }
                        Task { @MainActor in
                            if mode == .add {
                                await save()
                            } else {
                                await update()
                            }
                            
                            WidgetCenter.shared.reloadAllTimelines()
                            dismiss()
                        }
                    }
                    .bold()
                }
            }
            .alert("error", isPresented: $isNameErrorShown) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(nameError ?? "")
            }
            .alert("error", isPresented: $isDateErrorShown) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(dateError ?? "")
            }
            .onAppear {
                if let trash = trash, mode == .edit {
                    name = trash.name
                    category = trash.category
                    collectionDates = trash.date.sort()
                    notifyDay = trash.notifyDay
                    notifyTime = trash.notifyTime
                    comment = trash.comment
                    url = trash.url
                }
            }
            .onChange(of: name) { _, new in
                checkDuplication(for: new)
            }
        }
    }
    
    private func checkDuplication(for name: String) {
        let matched = trashes.filter { $0.name == name && $0.id != trash?.id }
        nameError = matched.isEmpty ? nil : String(localized: "error_duplicated_name")
    }
    
    private func deleteDates(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(collectionDates[index])
                collectionDates.remove(at: index)
            }
        }
    }
    
    private func save() async {
        if name.isEmpty {
            name = String(localized: category.label)
        }
        let newTrash = Trash(name, category: category, nextFrom: Date(), collectOn: collectionDates, notifyOn: notifyDay, at: notifyTime, comment: comment, url: url)
        modelContext.insert(newTrash)
        
        for date in collectionDates {
            let newDate = CollectionDate(on: date.frequency, date.dayOfWeek, in: newTrash)
            modelContext.insert(newDate)
            do {
                NotificationManager.cancelNotification(for: date.id.string)
                try await setupNotifications(for: date, in: newTrash)
            } catch {
                isNotificationErrorOccurred = true
                print(error)
                return
            }
        }
        try? modelContext.save()
    }
    
    private func update() async {
        guard let trash = trash else { return }
        trash.update(name, category: category, nextFrom: Date(), collectOn: collectionDates, notifyOn: notifyDay, at: notifyTime, comment: comment, url: url)
        
        for date in collectionDates {
            do {
                NotificationManager.cancelNotification(for: date.id.string)
                try await setupNotifications(for: date, in: trash)
            } catch {
                isNotificationErrorOccurred = true
                print(error)
                return
            }
            
            if date.trash != nil {
                continue
            }
            let newDate = CollectionDate(on: date.frequency, date.dayOfWeek, in: trash)
            modelContext.insert(newDate)
        }
        try? modelContext.save()
    }
    
    private func setupNotifications(for date: CollectionDate, in trash: Trash) async throws {
        if trash.notifyDay == .none {
            return
        }
        
        var components = DateComponents()
        // Set date
        var weekdayDiff = date.dayOfWeek.rawValue - trash.notifyDay.rawValue
        if weekdayDiff < 0 {
            weekdayDiff += 7
        }
        components.weekday = weekdayDiff
        if date.frequency != .every {
            components.weekdayOrdinal = date.frequency.rawValue
        }
        // Set time
        components.hour = Calendar.current.component(.hour, from: trash.notifyTime)
        components.minute = Calendar.current.component(.minute, from: trash.notifyTime)
        try await NotificationManager.scheduleNotification(
            for: date.id.string,
            title: trash.name,
            body: String(localized: "notification_body \(trash.name.lowercased()) \(String(localized: trash.notifyDay.relativeLabel).lowercased())"),
            on: components
        )
    }
    
    private func deleteDate(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                collectionDates.remove(at: index)
            }
        }
    }
}

//#Preview {
//    AddView()
//}
