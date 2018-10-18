//
//  WeatherLoader.swift
//  WindForecast
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import Foundation

final class WeatherLoader {
    
    enum WeatherError: Error {
        case decodingError
        case apiError(API.WeatherError)
    }
    
    enum Result {
        case success(Wind)
        case error(WeatherError)
    }
    
    static func wind(for city: String, completion: @escaping (Result) -> Void) {
        API.shared.wind(for: city) { (result) in
            switch result {
            case .success(let data):
                if let wind = Wind(data: data) {
                    completion(.success(wind))
                } else {
                    completion(.error(.decodingError))
                }
            case .error(let apiError):
                completion(.error(.apiError(apiError)))
            }
        }
    }
}
