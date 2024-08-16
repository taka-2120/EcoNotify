//
//  AboutView.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/16/24.
//

import SwiftUI
import EcoNotifyEntity
import EcoNotifyCore

struct AboutView: View {
    var body: some View {
        List {
            VStack(alignment: .center) {
                Image.appIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .cornerRadius(32)
                    .shadow(color: .black.opacity(0.2), radius: 15, y: 4)
                
                Text("Eco Notify")
                    .font(.title)
                    .fontWeight(.bold)
                
                Group {
                    //                        Text("version") + Text(detectVersion())
                }
                .foregroundColor(Color(.secondaryLabel))
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            Section("features") {
                NavigationLink {
                    //                    ReleaseNotesView()
                } label: {
                    Text("release_notes")
                }
                
                NavigationLink {
                    //                    UpcomingView()
                } label: {
                    Text("upcoming_features")
                }
            }
            
            Section("about_developer") {
                VStack(alignment: .leading) {
                    Text("developer")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 12) {
                        ZStack {
                            Rectangle()
                                .fill(.regularMaterial)
                            Image.profile
                                .resizable()
                                .frame(width: 64, height: 64)
                        }
                        .frame(width: 64, height: 64)
                        .cornerRadius(100)
                        
                        Text("Yu Takahashi")
                            .bold()
                    }
                }
                
                HStack {
                    Link(destination: URL(string: Constant.URL.portfolio.rawValue)!) {
                        HStack(spacing: 15) {
                            Text("portfolio")
                            Image(systemName: "arrow.up.forward.square")
                                .foregroundColor(Color(.secondaryLabel))
                        }
                        .foregroundColor(Color(.label))
                        .padding(8)
                    }
                    .buttonStyle(.plain)
                    .background(Color.accentColor)
                    .corner(radius: 10)
                    
                    Spacer()
                    
                    Link(destination: URL(string: Constant.URL.x.rawValue)!) {
                        Image.x
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                    }
                    .buttonStyle(.plain)
                    
                    Link(destination: URL(string: Constant.URL.github.rawValue)!) {
                        Image.github
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .overlay {
                                Circle().stroke(.white, lineWidth: 2)
                            }
                            .background(.white)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 5)
            }
            
            VStack(alignment: .center) {
                Link(destination: URL(string: Constant.URL.buyMeACoffee.rawValue)!) {
                    Image.buyMeACoffee
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                .buttonStyle(.plain)
                Text("bmc_notes")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .listRowBackground(Color.clear)
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .navigationTitle("about")
    }
}

#Preview {
    AboutView()
}
