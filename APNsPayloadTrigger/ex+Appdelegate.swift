//
//  ex+Appdelegate.swift
//  APNsPayloadTrigger
//
//  Created by heyht on 8/9/24.
//

import Foundation
import UIKit


extension NotificationsService: UIApplicationDelegate {
    // 6.
  /// 앱이 종료되었을 때에 노티를 탭한 경우 여기서 수신
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
   
    print(userInfo)
    return .newData
  }
 
    // 7.
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("앱이 APNs에 성공적으로 등록" )
      guard let accessToken = deviceToken.fetchAccessToken else {
          return
      }
      print("🏝️\(accessToken)🏝️" )
  }
}
