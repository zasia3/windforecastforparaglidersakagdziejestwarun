//
//  Endpoint.swift
//  WindForecast
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    static private let key = "96bb516c0b830887ef8319addc463ed9"
    
    static func city(matching name: String,
                     format: String) -> Endpoint {
        return Endpoint(
            path: "/forecast",
            queryItems: [
                URLQueryItem(name: "appid", value: key),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "q", value: name),
                URLQueryItem(name: "mode", value: format)
            ]
        )
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org/data/2.5"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

