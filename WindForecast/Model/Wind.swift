//
//  Wind.swift
//  WindForecast
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import Foundation

struct Wind: Codable {
    
    var speed: Double
    var direction: Double
    
    enum CodingKeys: String, CodingKey {

        case speed
        case direction = "deg"
    }
    
    var icon: String {
        
        let icons = ["N", "E", "S", "W"]
        
        let index = directionIndex(for: direction, in: 4)
        
        return icons[index]
        
    }
    
    var symbol: String {
        
        let symbols = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        
        let index = directionIndex(for: direction, in: 8)
        
        return symbols[index]
        
    }
    
    var index: Int {
        return directionIndex(for: direction, in: 8)
    }
    
    var emoji: String {
        
        let emojis = ["⬆️", "↗️", "➡️", "↘️", "⬇️", "↙️", "⬅️", "↖️"]
        
        let index = directionIndex(for: direction, in: 8)
        
        return emojis[index]
    }
    
    func directionIndex(for direction: Double, in counts: Double) -> Int {
        
        var initialValue: Double = 0
        let interval: Double = 360 / counts
        
        var minDiff = interval
        var value: Double = 0
        
        while initialValue < 360 + interval {
            
            let diff = fabs(direction - initialValue)
            if (diff < minDiff) {
                minDiff = diff
                value = initialValue
            }
            
            initialValue += interval
        }
        
        let index = value / interval
        
        return Int(index >= counts ? 0 : index)
    }
    
    init(speed: Double, direction: Double) {
        self.speed = speed
        self.direction = direction
    }
}
