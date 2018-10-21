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
    
    struct CacheObject: Codable {
        var date = Date()
        var data: Data!
    }
    
    static func cache(_ data: Data, for key: String, type: Types) {
        let defaults = UserDefaults.standard
        
        guard var dictionary = defaults.object(forKey: type.rawValue) as? [String:Data] else {
            var entry = CacheObject()
            entry.data = data
            if let entryData = try? JSONEncoder().encode(entry) {
                defaults.set([key: entryData], forKey: type.rawValue)
            }
            return
        }
        
        var entry = CacheObject()
        entry.data = data
        if let entryData = try? JSONEncoder().encode(entry) {
            dictionary[key] = entryData
        }
        defaults.set(dictionary, forKey: type.rawValue)
    }
    
    static func data(for key: String, type: Types, cacheTime: TimeInterval) -> Data? {
        
        let defaults = UserDefaults.standard
        
        guard var dictionary = defaults.object(forKey: type.rawValue) as? [String:Data],
            let objectData = dictionary[key] else { return nil }
                
        guard let object = try? JSONDecoder().decode(CacheObject.self, from: objectData) else { return nil }
        
        let timeDiff = Date().timeIntervalSince(object.date)
        
        if timeDiff <= cacheTime {
            return object.data
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
