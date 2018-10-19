//
//  API.swift
//  WindForecast
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import Foundation

final class API: NSObject {
    
    static let shared = API()
    
    enum WeatherError: Error {
        case incorrectRequest
        case apiError
        case unknown
    }
    
    enum Result {
        case success(Data)
        case error(WeatherError)
    }
    
    private lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
    }()
    
    func wind(for city: String, completion: @escaping (Result) -> Void) {
        
        guard !city.isEmpty else {
            completion(.error(.incorrectRequest))
            return
        }
        
        request(.city(matching: city, format: "json")) { result in

            completion(result)
        }
    }
    
    private func request(_ endpoint: Endpoint, completion: @escaping (Result) -> Void) {
        guard let url = endpoint.url else {
            return completion(.error(.incorrectRequest))
        }
        
        let task = session.dataTask(with: url) {
            data, _, error in
            
            let result = data.map(Result.success) ??
                .error(.apiError)
            
            completion(result)
        }
        
        task.resume()
    }
}
