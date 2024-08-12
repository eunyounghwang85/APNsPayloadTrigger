//
//  ex+uikit.swift
//  APNsPayloadTrigger
//
//  Created by heyht on 8/9/24.
//

import Foundation


extension Data {
    
    var fetchAccessToken : String? {
        
        let tokenParts = self.map{ data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        return token
        /*var token: String  = ""
        for i in 0..<devicetoken.count {
            token += String(format: "%02.2hhx", devicetoken[i] as CVarArg)
            
        }
        return token*/
    }
    
}
