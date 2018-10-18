//
//  Wind.swift
//  WindForecast
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import Foundation

struct Wind: Decodable {
    
    let speed: Double
    let direction: Double
    
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
    
    init?(data: Data) {
        speed = 0
        direction = 0
    }
}
