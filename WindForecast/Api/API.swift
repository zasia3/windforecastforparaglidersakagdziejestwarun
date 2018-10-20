//
//  API.swift
//  WindForecast
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import Foundation

final class API: NSObject {
    
    typealias Completion = (Result) -> Void
    
    static let shared = API()
    
    enum APIError: Error {
        case incorrectRequest
        case apiError
        case unknown
    }
    
    enum Result {
        case success(Data)
        case failure(APIError)
    }
    
    private var tasks = [Task]()
    
    private struct Task {
        var taskId: Int!
        var city: String!
        var completions = [Completion]()
    }
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "ForecastDownloadSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
    }()
    
    func wind(for city: String, completion: @escaping Completion) {
        
        guard !city.isEmpty else {
            completion(.failure(.incorrectRequest))
            return
        }
        
        let existingTasks = tasks.filter{ $0.city == city }
        if var task = existingTasks.first {
            task.completions.append(completion)
            return
        }
        
        request(.city(matching: city, format: "json"), city: city, completion: completion)
    }
    
    private func request(_ endpoint: Endpoint, city: String, completion: @escaping Completion) {
        guard let url = endpoint.url else {
            return completion(.failure(.incorrectRequest))
        }
        
        let sessionTask = session.dataTask(with: url)
        var task = Task()
        task.taskId = sessionTask.taskIdentifier
        task.city = city
        task.completions.append(completion)
        
        tasks.append(task)
        
        sessionTask.resume()
    }
}

extension API: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        processTask(with: dataTask.taskIdentifier, data: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        processTask(with: task.taskIdentifier, data: nil)
    }
    
    func processTask(with identifier: Int, data: Data?) {
        
        let existingTasks = tasks.filter{ $0.taskId == identifier }
        guard let task = existingTasks.first else { return }
        
        for completion in task.completions {
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.apiError))
            }
        }
        if let index = tasks.index(where: { $0.taskId == task.taskId }) {
            tasks.remove(at: index)
        }
    }
}
