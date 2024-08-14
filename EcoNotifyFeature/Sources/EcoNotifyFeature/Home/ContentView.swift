//
//  ContentView.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUI
import SwiftData
import WidgetKit
import ActivityKit
import AppTrackingTransparency
import GoogleMobileAds
import EcoNotifyEntity
import EcoNotifyCore

public struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Trash.next) private var trashes: [Trash]
    @State private var iapManager = IAPManager.shared
    @State private var nativeAdViewModel = NativeAdViewModel.shared
    @State private var isAddSheetShown = false
    @State private var isSettingsSheetShown = false
    @State private var isLoading = true
    @State private var nextCollection: Trash? = nil
    private let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    
    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    if trashes.isEmpty {
                        VStack {
                            Spacer()
                            Text("empty_collection")
                                .font(.title3)
                                .bold()
                                .multilineTextAlignment(.center)
                            Spacer()
                            if !iapManager.isAdsRemoved {
                                NativeAdView(using: nativeAdViewModel)
                                    .frame(height: 160)
                                    .corner(radius: 10)
                                    .padding()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
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
                            
                            ForEach(Array(trashes.enumerated()), id: \.offset) { index, trash in
                                TrashItem(for: trash)
                            }
                            .onDelete(perform: deleteItems)
                            
                            if !iapManager.isAdsRemoved {
                                NativeAdView(using: nativeAdViewModel)
                                    .frame(height: 160)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                }
                .padding(.bottom, iapManager.isAdsRemoved ? 0 : 60)
                
                if !iapManager.isAdsRemoved {
                    VStack(spacing: 0) {
                        Spacer()
                        BannerAdView()
                            .frame(height: 60)
                        Rectangle()
                            .fill(.regularMaterial)
                            .ignoresSafeArea()
                            .frame(height: keyWindow?.safeAreaInsets.bottom ?? 0)
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
            .sheet(isPresented: $isSettingsSheetShown) {
                SettingsView()
            }
            .refreshable {
                Task { @MainActor in
                    updateNext()
                }
            }
            .onAppear {
                Task { @MainActor in
                    do {
                        isLoading = true
                        try await iapManager.retrieveProducts()
                        await iapManager.updatePurchasedProducts()
                        if !iapManager.isAdsRemoved {
                            nativeAdViewModel.isLoading = true
                            nativeAdViewModel.refreshAd()
                        }
                        updateNext()
                        try await NotificationManager.request()
                        isLoading = false
                    } catch {
                        print(error)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: showSettingsSheet) {
                        Image(systemName: "gearshape")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .disabled(trashes.isEmpty)
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("add", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("title")
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in })
            }
            .overlay {
                if nativeAdViewModel.isLoading || isLoading {
                    LoadingView()
                }
            }
        }
    }

    private func addItem() {
        isAddSheetShown.toggle()
    }
    
    private func showSettingsSheet() {
        isSettingsSheetShown.toggle()
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
