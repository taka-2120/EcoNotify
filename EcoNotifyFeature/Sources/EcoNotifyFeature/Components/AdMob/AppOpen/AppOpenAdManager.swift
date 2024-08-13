//
//  AppOpenAdViewModel.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 8/13/24.
//

import Foundation
import GoogleMobileAds
import EcoNotifyEntity

@Observable
@preconcurrency
class AppOpenAdManager: NSObject {
    var appOpenAd: GADAppOpenAd?
    var isLoadingAd = false
    var isShowingAd = false
    
    @MainActor static let shared = AppOpenAdManager()
    
    private override init() {
        super.init()
    }
    
    private func loadAd() async {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
        
        
        var adUnitId: String {
            #if DEBUG
            Constant.AdMob.AppOpen.debug.rawValue
            #else
            Constant.AdMob.AppOpen.release.rawValue
            #endif
        }
        
        do {
            appOpenAd = try await GADAppOpenAd.load(
                withAdUnitID: adUnitId,
                request: GADRequest())
        } catch {
            print("App open ad failed to load with error: \(error.localizedDescription)")
        }
        isLoadingAd = false
    }
    
    func showAdIfAvailable(in vc: UIViewController) {
        // If the app open ad is already showing, do not show the ad again.
        guard !isShowingAd else { return }
        
        // If the app open ad is not available yet but is supposed to show, load
        // a new ad.
        if !isAdAvailable() {
            Task {
                await loadAd()
            }
            return
        }
        
        if let ad = appOpenAd {
            isShowingAd = true
            ad.present(fromRootViewController: vc)
        }
    }
    
    private func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        return appOpenAd != nil
    }
}
