//
//  APNsPayloadTriggerApp.swift
//  APNsPayloadTrigger
//
//  Created by heyht on 8/9/24.
//

import SwiftUI

import FirebaseCore
import FirebaseMessaging


@main
struct APNsPayloadTriggerApp: App {
    
    var notificationService = NotificationsService()
    
    // MARK: 아직도 해줘야함
    @UIApplicationDelegateAdaptor private var NotificationDelegate: NotificationsService

    init() {
        
        UIApplication.shared.delegate = NotificationsService.shared
        // MARK: ------
        // MARK: ➡️ FCM 추가시
        //import FirebaseCore
        FirebaseApp.configure()
        //import FirebaseMessaging
        notificationService.setDelegate()
        // MARK: ⬅️ ------
        notificationService.requestPushPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
