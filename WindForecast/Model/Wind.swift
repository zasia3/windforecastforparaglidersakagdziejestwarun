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
        
        if direction <= 45, direction >= 315 { return "N" }
        if direction <= 135, direction > 45 { return "E" }
        if direction <= 225, direction > 135 { return "S" }
        return "W"
    }
    
    init(speed: Double, direction: Double) {
        self.speed = speed
        self.direction = direction
    }
}
