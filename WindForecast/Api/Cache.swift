//
//  Cache.swift
//  WindForecast
//
//  Created by MacBook Pro on 20.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import Foundation

class Cache {
    
    enum Types: String {
        case forecast
    }
    
    static func cache(_ data: Data, for key: String, type: Types) {
        
        let defaults = UserDefaults.standard
        
        guard var dictionary = defaults.object(forKey: type.rawValue) as? [String:[String : Any]] else {
            let entry = ["date": Date(), "data": data] as [String : Any]
            defaults.set([key: entry], forKey: type.rawValue)
            return
        }
        
        let entry = ["date": Date(), "data": data] as [String : Any]
        dictionary[key] = entry
        defaults.set(dictionary, forKey: type.rawValue)
    }
    
    static func data(for key: String, type: Types) -> Data? {
        
        let defaults = UserDefaults.standard
        
        guard let dictionary = defaults.object(forKey: type.rawValue) as? [String:[String : Any]],
            let object = dictionary[key],
            let date = object["date"] as? Date else { return nil }
        
        let timeDiff = Date().timeIntervalSince(date)
        
        if timeDiff <= 3600 {
            return object["data"] as? Data
        }
        
        return nil
    }
    
    static func clear(for key: String, type: Types) {
        let defaults = UserDefaults.standard
        
        guard var dictionary = defaults.object(forKey: type.rawValue) as? [String:[String : Any]],
            let _ = dictionary[key] else { return }
        
        dictionary.removeValue(forKey: key)
        
        defaults.set(dictionary, forKey: type.rawValue)
    }
}
