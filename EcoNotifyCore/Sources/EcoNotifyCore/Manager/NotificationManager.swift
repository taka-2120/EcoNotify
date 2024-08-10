//
//  NotificationManager.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 7/29/24.
//

import UserNotifications

public final class NotificationManager {
    public static func request() async throws {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
    }
    
    public static func scheduleNotification(for id: String, title: String, body: String, on date: DateComponents, repeats: Bool = true) async throws {
        // Contents
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        // Schedule
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        
        print("Scheduled: \(date)")
        
        // Setup notification
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        try await notificationCenter.add(request)
    }
    
    public static func cancelNotification(for id: String) {
        print("Cancelled: \(id)")
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
}
