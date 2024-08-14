//
//  AppDelegate.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/29/24.
//

import SwiftData
import UIKit
import GoogleMobileAds
import EcoNotifyEntity
import EcoNotifyFeature
import AdSupport

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
     func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        #if DEBUG
        print("Ad ID: \(ASIdentifierManager().advertisingIdentifier)")
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "d8f772976c775a39035234004090b007" ]
        #endif
        return true
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if response.notification.request.content.categoryIdentifier ==
            NotificationValue.trashReminderCategory.rawValue {
            let trashTitle = userInfo[NotificationValue.trashTitle.rawValue] as! String
            
            switch response.actionIdentifier {
            case NotificationValue.tookOutAction.rawValue,
                NotificationValue.cancelAction.rawValue:
                
                let context = ModelContext(sharedModelContainer)
                let descriptor = FetchDescriptor<Trash>()
                let trashes = try? context.fetch(descriptor)
                let target = (trashes ?? []).filter { trash in
                    trash.name == trashTitle
                }
                guard let target = target.first else {
                    return
                }
                
                target.setNext()
                
                break
                
            case UNNotificationDefaultActionIdentifier,
            UNNotificationDismissActionIdentifier:
                break
                
            default: break
            }
        }
        
        completionHandler()
    }
}
