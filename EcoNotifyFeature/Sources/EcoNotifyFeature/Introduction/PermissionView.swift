//
//  PermissionView.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/16/24.
//

import SwiftUI
import AppTrackingTransparency
import EcoNotifyEntity
import EcoNotifyCore

struct PermissionView: View {
    
    @State private var isNotificationsApproved: Bool? = nil
    @State private var isATTApproved: Bool? = nil
    private var canContinue: Bool {
        isNotificationsApproved != nil && isATTApproved != nil
    }
    
    var body: some View {
        VStack {
            Text("permissions")
                .font(.title)
                .fontWeight(.semibold)
            
            Spacer()
            
            buildPermissionCard(
                icon: "bell",
                approved: isNotificationsApproved,
                title: "notifications",
                description: "notification_description") {
                    Task {
                        do {
                            isNotificationsApproved = try await NotificationManager.request()
                        } catch {
                            print(error)
                        }
                    }
                }
                .padding(.bottom, 20)
            
            buildPermissionCard(
                icon: "point.bottomleft.forward.to.point.topright.scurvepath",
                approved: isATTApproved,
                title: "tracking",
                description: "tracking_description") {
                    Task {
                        let status = await ATTrackingManager.requestTrackingAuthorization()
                        switch status {
                        case .authorized: isATTApproved = true
                        default: isATTApproved = false
                        }
                    }
                }
            
            Spacer()
            
            Button {
                UserDefaults.standard.set(
                    true,
                    forKey: Constant.UserDefaultsKey.isFirstLaunched.rawValue)
            } label: {
                Text("dive_in")
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .background(.white)
            .foregroundStyle(.black)
            .corner(radius: .infinity)
            .shadow()
            .opacity(canContinue ? 1 : 0.8)
            .disabled(!canContinue)
        }
        .padding()
        .background(Color.accentColor.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .animation(.easeInOut, value: isNotificationsApproved)
        .animation(.easeInOut, value: isATTApproved)
    }
    
    private func buildPermissionCard(
        icon: String,
        approved: Bool?,
        title: LocalizedStringResource,
        description: LocalizedStringResource,
        action: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .symbolRenderingMode(.multicolor)
                    .imageScale(.large)
                    .padding(8)
                    .background(.regularMaterial)
                    .corner()
                
                Spacer()
                
                switch approved {
                case true:
                    Image(systemName: "checkmark")
                        .bold()
                        .foregroundStyle(.blue)
                        .padding(10)
                        .background(.regularMaterial)
                        .corner(radius: .infinity)
                case false:
                    Text("denied")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .bold()
                        .foregroundStyle(.red)
                        .background(.regularMaterial)
                        .corner(radius: .infinity)
                default:
                    Button {
                        action()
                    } label: {
                        Text("approve")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .bold()
                    }
                    .background(.regularMaterial)
                    .corner(radius: .infinity)
                }
            }
            
            Text(title)
                .font(.title3)
                .bold()
            Text(description)
        }
        .padding()
        .background(.white)
        .corner(radius: 20)
        .shadow()
    }
}

#Preview {
    PermissionView()
}
