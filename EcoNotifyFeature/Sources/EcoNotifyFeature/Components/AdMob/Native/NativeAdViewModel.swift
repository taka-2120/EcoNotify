//
//  NativeAdViewModel.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/13/24.
//

import SwiftUI
import GoogleMobileAds
import EcoNotifyEntity

@Observable
class NativeAdViewModel: NSObject, GADNativeAdLoaderDelegate, GADNativeAdDelegate {
    @MainActor static let shared = NativeAdViewModel()
    private override init() {
        super.init()
    }
    
    var nativeAd: GADNativeAd?
    private var adLoader: GADAdLoader!
    
    func refreshAd() {
        var adUnitId: String {
            #if DEBUG
            Constant.AdMob.Native.debug.rawValue
            #else
            Constant.AdMob.Native.release.rawValue
            #endif
        }
        adLoader = GADAdLoader(
            adUnitID: adUnitId,
            rootViewController: nil,
            adTypes: [.native], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        self.nativeAd = nativeAd
        nativeAd.delegate = self
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}
