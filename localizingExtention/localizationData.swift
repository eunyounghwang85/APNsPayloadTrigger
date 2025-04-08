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

extension localizationData {
    
    
    init(_ language:String = "", _ title:String = "", _ body:String = "") {
        let data = try! JSONSerialization.data(withJSONObject: ["language": "\(language)", "title": title, "body" : body])
        self = try! JSONDecoder().decode(Self.self, from: data)
    }
    
}
//MARK: ⏤⏤⏤⏤
//MARK: 🌻custom UNMutableNotificationContent
let dataKey = "data"
//let localizationDataKey = "localization_data"
extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

final class injectionUNNotificationContent {

    private let localContents : [localizationData]
    
    init?(apnsPayload: [AnyHashable : Any]) {
        
        /*if let jsondata = try? JSONSerialization.data(withJSONObject: apnsPayload, options: .prettyPrinted) {
            print("🌝\(String(describing: String(data: jsondata, encoding: .utf8)))🌝")
        }*/
        
       // print("🌝\(String(describing: apnsPayload))🌝")
    
        if let alert = (apnsPayload["aps"] as? [AnyHashable : Any])?["alert"]  as? [AnyHashable : Any],
           let title = alert["loc-key"] as? String,
           
            
           let valus = alert["loc-args"] as? [String] {
            print("🌝\(title)🌝")
            print("🐣\(valus)🐣")
            self.localContents = ["ko","en"].map({
                let localizeValus = valus.map({
                    $0.localized()
                })
                let localizebody = String(format: title.localized(), localizeValus.first!, localizeValus.last!)
                
                return localizationData($0,  $0 == "ko" ? "한글푸쉬테스트" : "English push text ", localizebody)
            })
            
        }else{
         
            var newar = [localizationData]()
           
            var title = ""
            var body = ""
            _ = apnsPayload.map({
                guard let st = $0.key as? String, let v = $0.value as? String,
                ["-title", "-body"].contains(where: {
                    st.contains($0)
                }) else {
                    return
                }
               
                
                var le = st.replacingOccurrences(of: "-title", with: "")
                le = st.replacingOccurrences(of: "-body", with: "")
                
                if st.contains("-title") {
                    title = v
                   
                }else{
                    body = v
                }
                
                if let fir = newar.first(where: {$0.language == le}){
                    newar.removeAll(where: {$0.language == le})
                    title = title.isEmpty ? fir.title : title
                    body = body.isEmpty ? fir.body : body
                    
                }
                
                newar.append(localizationData.init(le, title, body))
                title = ""
                body = ""
              
            })
            guard !newar.isEmpty  else {
                return nil
            }
            /*
            guard let data = apnsPayload[dataKey] as? [[String:Any]],
                  let jsondata = try? JSONSerialization.data(withJSONObject: data, options: []),
                  let lContentList  =  try? JSONDecoder().decode([localizationData].self, from: jsondata) else {
                return nil
            }*/
            self.localContents = newar
            
        }
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
