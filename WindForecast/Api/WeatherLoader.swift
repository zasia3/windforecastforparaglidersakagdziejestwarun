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
    
    static func windForecast(for city: String, force: Bool, completion: @escaping (Result) -> Void) {
        
        if !force {
            if let data = Cache.data(for: city.uppercased(), type: .forecast) {
                processData(data, completion: completion)
                return
            }
        }
        
        API.shared.wind(for: city) { (result) in
            
            switch result {
            case .success(let data):
                Cache.cache(data, for: city.uppercased(), type: .forecast)
                processData(data, completion: completion)
                
            case .failure(let apiError):
                
                completion(.failure(.apiError(apiError)))
            }
        }
    }
    
    static func processData(_ data: Data, completion: @escaping (Result) -> Void) {
        
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
    }
}
