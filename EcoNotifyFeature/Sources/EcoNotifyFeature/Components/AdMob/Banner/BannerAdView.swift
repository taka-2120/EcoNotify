//
//  BannerAdView.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/13/24.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = BannerAdViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
