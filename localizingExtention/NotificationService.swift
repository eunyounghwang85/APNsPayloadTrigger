//
//  NotificationService.swift
//  localizingExtention
//
//  Created by heyht on 8/12/24.
//

import UserNotifications



class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return self.contentHandler = nil
        }
        
        defer {
            if let handelr = self.contentHandler {
                handelr(bestAttemptContent)
            }
        }
        guard let localizeData = injectionUNNotificationContent(apnsPayload: bestAttemptContent.userInfo),
              let currentContent = localizeData.getContent else {
            return
        }
        
        bestAttemptContent.title = currentContent.title
        bestAttemptContent.body = currentContent.body
        
       /* if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            contentHandler(bestAttemptContent)
        } */
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

 
