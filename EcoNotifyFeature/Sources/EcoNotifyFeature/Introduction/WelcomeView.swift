//
//  WelcomeView.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/16/24.
//

import SwiftUI
import EcoNotifyEntity
import EcoNotifyCore

extension Image {
    @MainActor func circleIcon(radius: CGFloat, rotate: Double = 0, scale: CGFloat, offset: CGPoint = .zero) -> some View {
        self
            .resizable()
            .frame(width: radius, height: radius)
            .padding()
            .background(.white)
            .clipShape(.circle)
            .rotationEffect(.degrees(rotate))
            .scaleEffect(scale)
            .offset(x: offset.x, y: offset.y)
            .shadow()
    }
}

public struct WelcomeView: View {
    
    @State private var scalePlastic: CGFloat = 0
    @State private var scaleBottle: CGFloat = 0
    @State private var scaleCardboard: CGFloat = 0
    @State private var scalePlasticBottle: CGFloat = 0
    @State private var scaleNotBurnable: CGFloat = 0
    @State private var scaleBurnable: CGFloat = 0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack {
                Text("Eco Notify")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)

                Text("widget_description")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                Spacer()
                    .overlay {
                        ZStack(alignment: .center) {
                            // Top
                            Image(TrashCategory.plastic.image)
                                .circleIcon(radius: 85, rotate: -20, scale: scalePlastic, offset: .init(x: -40, y: -110))
                            
                            Image(TrashCategory.bottle.image)
                                .circleIcon(radius: 85, rotate: 10, scale: scaleBottle, offset: .init(x: 85, y: -65))
                            
                            // Left
                            Image(TrashCategory.cardboard.image)
                                .circleIcon(radius: 85, rotate: 5, scale: scaleCardboard, offset: .init(x: -110, y: -10))
                            
                            // Bottom
                            Image(TrashCategory.plasticBottle.image)
                                .circleIcon(radius: 85, rotate: -10, scale: scalePlasticBottle, offset: .init(x: -50, y: 100))
                            
                            Image(TrashCategory.notBurnable.image)
                                .circleIcon(radius: 85, rotate: 10, scale: scaleNotBurnable, offset: .init(x: 80, y: 70))
                            
                            // Center
                            Image(TrashCategory.burnable.image)
                                .circleIcon(radius: 150, scale: scaleBurnable)
                        }
                    }
                
                NavigationLink {
                    PermissionView()
                } label: {
                    Text("continue")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .background(.white)
                .foregroundStyle(.black)
                .corner(radius: .infinity)
                .shadow()
            }
            .padding()
            .background(Color.accentColor.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    withAnimation(.bouncy) {
                        scalePlastic = 1
                        scaleBottle = 1
                        scaleCardboard = 1
                        scalePlasticBottle = 1
                        scaleNotBurnable = 1
                        scaleBurnable = 1
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
