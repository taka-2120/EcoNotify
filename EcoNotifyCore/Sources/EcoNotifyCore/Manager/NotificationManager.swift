//
//  NotificationManager.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 7/29/24.
//

import UserNotifications
import EcoNotifyEntity

public final class NotificationManager {
    public static func request() async throws {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
        
        // Define the custom actions.
        let tookOutAction = UNNotificationAction(
            identifier: NotificationValue.tookOutAction.rawValue,
            title: String(localized: "took_out"),
            options: [])
        let skipAction = UNNotificationAction(
            identifier: NotificationValue.skipAction.rawValue,
            title: String(localized: "skip"),
            options: [])
        let cancelAction = UNNotificationAction(
            identifier: NotificationValue.cancelAction.rawValue,
            title: String(localized: "cancel"),
            options: [])
        // Define the notification type
        let trashReminderCategory =
              UNNotificationCategory(
                identifier: NotificationValue.trashReminderCategory.rawValue,
                actions: [tookOutAction, skipAction, cancelAction],
                intentIdentifiers: [],
                hiddenPreviewsBodyPlaceholder: "",
                options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([trashReminderCategory])
    }
    
    public static func scheduleNotification(for id: String, title: String, body: String, on date: DateComponents, repeats: Bool = true) async throws {
        // Contents
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = [NotificationValue.trashTitle.rawValue: title]
        content.categoryIdentifier = NotificationValue.trashReminderCategory.rawValue
        
        // Schedule
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        
        // Setup notification
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        try await notificationCenter.add(request)
    }
    
    public static func cancelNotification(for id: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
}
