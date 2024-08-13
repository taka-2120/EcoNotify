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
    var nativeAd: GADNativeAd?
    private var adLoader: GADAdLoader!
    
    func refreshAd() {
        var adUnitId: String {
            #if DEBUG
            Constant.AdMob.debug.rawValue
            #else
            Constant.AdMob.release.rawValue
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
        // Native ad data changes are published to its subscribers.
        self.nativeAd = nativeAd
        nativeAd.delegate = self
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}
