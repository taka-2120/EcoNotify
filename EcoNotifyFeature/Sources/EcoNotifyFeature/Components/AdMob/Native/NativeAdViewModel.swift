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
public class NativeAdViewModel: NSObject, GADNativeAdLoaderDelegate, GADNativeAdDelegate {
    @MainActor public static let shared = NativeAdViewModel()
    private override init() {
        super.init()
    }
    
    public var isLoading = true
    // TODO: Handle errors occurred
    internal var nativeAd: GADNativeAd?
    private var adLoader: GADAdLoader?
    
    internal func refreshAd() {
        var adUnitId: String {
            #if DEBUG
            Constant.AdMob.Native.debug.rawValue
            #else
            Constant.AdMob.Native.release.rawValue
            #endif
        }
        let multipleAdOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdOptions.numberOfAds = 5;
        adLoader = GADAdLoader(
            adUnitID: adUnitId,
            rootViewController: nil,
            adTypes: [.native], options: [multipleAdOptions])
        adLoader!.delegate = self
        adLoader!.load(GADRequest())
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        self.nativeAd = nativeAd
        nativeAd.delegate = self
        withAnimation {
            isLoading = false
        }
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}
