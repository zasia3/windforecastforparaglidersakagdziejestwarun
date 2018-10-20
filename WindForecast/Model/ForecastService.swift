//
//  ForecastService.swift
//  WindForecast
//
//  Created by MacBook Pro on 19.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import Foundation


struct ForecastService: Decodable {
    
    var list: [WeatherForecast]
}

struct WeatherForecast: Decodable {
    var dt_txt: String
    var wind: Wind
}

struct Forecast {
    
    var windForecasts: [WeatherForecast]
    
    init(from service: ForecastService) {
        
        windForecasts = []
        
        for forecast in service.list {
            windForecasts.append(forecast)
        }
    }
}
