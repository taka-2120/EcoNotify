//
//  ActivityManager.swift
//  EcoNotifyFeature
//
//  Created by Yu Takahashi on 7/20/24.
//

import ActivityKit
import Foundation
import UIKit

public class ActivityManager {
    public static func request(for name: String, color: String) {
        let attributes = EcoNotifyActivityAttributes(name: name, color: color)
        
        do {
            let content = ActivityContent(state: EcoNotifyActivityAttributes.ContentState(), staleDate: nil, relevanceScore: 1.0)
            _ = try Activity.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public static func endActivity(for id: String) async {
        let activity = Activity<EcoNotifyActivityAttributes>.activities.filter { $0.id == id }
        print(Activity<EcoNotifyActivityAttributes>.activities)
        guard let activity = activity.first else {
            return
        }
        let content = ActivityContent(state: EcoNotifyActivityAttributes.ContentState(), staleDate: nil, relevanceScore: 1.0)
        await activity.end(content, dismissalPolicy: .immediate)
    }
}
