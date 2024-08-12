//
//  localizationData.swift
//  localizingExtention
//
//  Created by heyht on 8/12/24.
//

import Foundation


//MARK: 🌻localizationData - Codable
struct localizationData : Codable {
    
    let language:String
    var title:String
    var body:String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        language = (try? values.decode(String.self, forKey: .language)) ?? ""
        title = (try? values.decode(String.self, forKey: .title)) ?? ""
        body = (try? values.decode(String.self, forKey: .body)) ?? ""
        
    }
}
//MARK: ⏤⏤⏤⏤
//MARK: 🌻custom UNMutableNotificationContent
let dataKey = "data"
//let localizationDataKey = "localization_data"

final class injectionUNNotificationContent {

    private let localContents : [localizationData]
    
    init?(apnsPayload: [AnyHashable : Any]) {
        guard let data = apnsPayload[dataKey] as? [[String:Any]],
              let jsondata = try? JSONSerialization.data(withJSONObject: data, options: []),
              let lContentList  =  try? JSONDecoder().decode([localizationData].self, from: jsondata) else {
            return nil
        }
        self.localContents = lContentList
    }
}

extension injectionUNNotificationContent {
    var getContent : localizationData? {
        return localContents.first(where: {$0.language == AppLangCode})
    }
}
//MARK: ⏤⏤⏤⏤
// MARK: 🌻Common + Extention
public var getDeviceLocale : Locale {
//    let localeID = Locale.preferredLanguages.first ?? "en"
//    return Locale(identifier: localeID)
    return  Locale.autoupdatingCurrent
}


public var AppLangCode: String{
    let currentLocale  = getDeviceLocale
    guard let code = currentLocale.language.languageCode?.identifier,
          ["ko", "ja", "vi","en"].contains(code) else{
        // default ko
        return "ko"
    }
    return code
}
//MARK: ⏤⏤⏤⏤
