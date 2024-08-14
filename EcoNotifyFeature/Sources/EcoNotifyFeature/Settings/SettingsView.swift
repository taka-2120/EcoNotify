//
//  SettingsView.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/13/24.
//

import SwiftUI
import StoreKit
import EcoNotifyEntity
import EcoNotifyCore

struct SettingsView: View {
    
    @State private var iapManager = IAPManager.shared
    @State private var country = ""
    @State private var prefecture = ""
    @State private var isOfferCodeSheetShown = false
    private var removeAds: Product? {
        return iapManager.products.filter { $0.id == Constant.ProductId.removeAds.rawValue }.first
    }
    
    var body: some View {
        NavigationStack {
            List {
//                Picker("country", selection: $country) {
//
//                }
//                Picker("prefecture", selection: $country) {
//
//                }
                
                if let removeAds = removeAds {
                    Section {
                        HStack {
                            Label("remove_ads", systemImage: "megaphone.fill")
                            Spacer()
                            if iapManager.isAdsRemoved {
                                Text("purchased")
                            } else {
                                Text(removeAds.displayPrice)
                            }
                        }
                        
                        if !iapManager.isAdsRemoved {
                            VStack(spacing: 15) {
                                Button {
                                    Task { @MainActor in
                                        do {
                                            _ = try await iapManager.purchase(removeAds)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text("buy")
                                            .padding(10)
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.borderless)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .corner()
                                
                                Button {
                                    Task { @MainActor in
                                        await iapManager.restorePurchases()
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        Label("restore_purchase", systemImage: "arrow.clockwise")
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.borderless)
                                
                                Button {
                                    isOfferCodeSheetShown.toggle()
                                } label: {
                                    HStack {
                                        Spacer()
                                        Label("redeem_code", systemImage: "ticket.fill")
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
                
                Section {
                    Button {
                        
                    } label: {
                        Label("license", systemImage: "text.quote")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("about", systemImage: "app.badge")
                    }

                    HStack {
                        Label("version", systemImage: "info.circle.fill")
                        Spacer()
                        Text("1.0.0")
                    }
                }
            }
            .navigationTitle("settings")
            .offerCodeRedemption(isPresented: $isOfferCodeSheetShown)
        }
    }
}

#Preview {
    SettingsView()
}
