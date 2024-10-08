//
//  Constants.swift
//  EcoNotifyEntity
//
//  Created by Yu Takahashi on 8/13/24.
//

public enum Constant {
    public enum AdMob {
        public enum Native: String {
            case release = "ca-app-pub-8585341779496895/9591816613"
            case debug = "ca-app-pub-3940256099942544/3986624511"
        }
        public enum AppOpen: String {
            case release = "ca-app-pub-8585341779496895/8654139461"
            case debug = "ca-app-pub-3940256099942544/5575463023"
        }
        public enum Banner: String {
            case release = "ca-app-pub-8585341779496895/8654139461"
            case debug = "ca-app-pub-3940256099942544/2435281174"
        }
    }
    
    public enum ProductId: String, CaseIterable {
        case removeAds = "yutakahashi.EcoNotify.RemoveAds"
    }
    
    public enum URL: String {
        case x = "https://x.com/yutk_941"
        case github = "https://github.com/taka-2120"
        case portfolio = "https://yu-dev.vercel.app/"
        case buyMeACoffee = "buymeacoffee.com/yutakahashi"
    }
    
    public enum UserDefaultsKey: String {
        case isFirstLaunched = "isFirstLaunchedKey"
    }
}
