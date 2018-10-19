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
        case failure(WeatherError)
    }
    
    static func wind(for city: String, completion: @escaping (Result) -> Void) {
        API.shared.wind(for: city) { (result) in
            switch result {
            case .success(let data):
                
                guard let forecastService = try? JSONDecoder().decode(ForecastService.self, from: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                let forecast = Forecast(from: forecastService)
                
                if let wind = forecast.windForecasts.first {
                    completion(.success(wind))
                } else {
                    completion(.failure(.decodingError))
                }
               
            case .error(let apiError):
                completion(.failure(.apiError(apiError)))
            }
        }
    }
}
