//
//  Favourites.swift
//  WindForecast
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import Foundation

struct Favourites {
    
    static private let citiesKey = "favourite_cities"
    
    static func favouriteCities() -> [String] {
        
        let defaults = UserDefaults.standard
        
        return defaults.object(forKey: citiesKey) as? [String] ?? []
    }
    
    static func add(_ city: String) {
        
        let defaults = UserDefaults.standard
        
        guard var cities = defaults.object(forKey: citiesKey) as? [String] else {
            defaults.set([city], forKey: citiesKey)
            return
        }
        
        guard !cities.contains(city) else { return }
        
        cities.append(city)
        defaults.set(cities, forKey: citiesKey)
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: citiesKey)
    }
}
