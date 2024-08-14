//
//  NotificationService.swift
//  APNsPayloadTrigger
//
//  Created by heyht on 8/9/24.
//

import Foundation
import UserNotifications
import UIKit

// UNUserNotificationCenterDelegate의 메소드 구현
class NotificationsService: NSObject, UNUserNotificationCenterDelegate {
  static let shared = NotificationsService()
    

    // 1.
  func requestPushPermission() {
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
      if granted {
        print("User granted Notification Permissions")
      } else if let error = error {
        print("에러: \(error)")
      }
    }
  
    DispatchQueue.main.async {
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
  
    // 2.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo

        print(userInfo)
        return [.banner, .list, .sound]
      }
    
    // 3.
  /// 백그라운드에서 받은 Push 데이터 처리
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo
      if let jsondata = try? JSONSerialization.data(withJSONObject: userInfo, options: []) {
          print("🤯\(String(data: jsondata, encoding: .utf8))🤯")
      }

    print(userInfo)
  }
}
