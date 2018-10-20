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
        case apiError(API.APIError)
        
        var description: String {
            switch self {
            case .decodingError:
                return "Could not decode received data"
            case .apiError(_):
                return "Could not retrieve data"
            }
        }
    }
    
    enum Result {
        case success(Forecast)
        case failure(WeatherError)
    }
    
    static func windForecast(for city: String, completion: @escaping (Result) -> Void) {
        API.shared.wind(for: city) { (result) in
            switch result {
            case .success(let data):
                
                guard let forecastService = try? JSONDecoder().decode(ForecastService.self, from: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                let forecast = Forecast(from: forecastService)
                
                if forecast.windForecasts.first != nil {
                    completion(.success(forecast))
                } else {
                    completion(.failure(.decodingError))
                }
               
            case .failure(let apiError):
                completion(.failure(.apiError(apiError)))
            }
        }
    }
}
