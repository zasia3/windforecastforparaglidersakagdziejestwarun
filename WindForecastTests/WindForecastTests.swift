//
//  WindForecastTests.swift
//  WindForecastTests
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import XCTest
@testable import WindForecast

class WindForecastTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        
        Favourites.clear()
        
        super.tearDown()
    }
    
    func testWindIcon() {
        let testWind = Wind(speed: 0, direction: 47.5)
        XCTAssertEqual(testWind.icon, "E", "Wind should blow into the East")
    }
    
    func testRequestWithEmptyCity() {
        
        let expect = expectation(description: #function)
        
        WeatherLoader.windForecast(for:"", force: true){ (result) in
            
            if case .failure(_) = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testRequest() {
        let expect = expectation(description: #function)
        
        WeatherLoader.windForecast(for:"Leeds", force: true){ (result) in
            
            if case .success(_) = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFavourites() {
        
        let cities = Favourites.favouriteCities()
        
        XCTAssertEqual(cities.count, 0, "Initially there are no favourite cities")
        
        Favourites.add("Leeds")
        Favourites.add("Łódź")
        
        let favouriteCities = Favourites.favouriteCities()
        
        XCTAssertEqual(favouriteCities.count, 2, "Two cities should be returned")
    }
    
    func testDirectionIndex() {
        let testWind = Wind(speed: 0, direction: 0)
        
        var index = testWind.directionIndex(for: 4, in: 8)
        XCTAssertEqual(index, 0)
        
        index = testWind.directionIndex(for: 355, in: 8)
        XCTAssertEqual(index, 0)
        
        index = testWind.directionIndex(for: 280, in: 8)
        XCTAssertEqual(index, 6)
        
        index = testWind.directionIndex(for: 270, in: 8)
        XCTAssertEqual(index, 6)
    }
    
    func testCache() {
        
        let text = "tralala"
        guard let data = text.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        Cache.cache(data, for: "testCache", type: .forecast)
        
        sleep(2)
        
        var cachedData = Cache.data(for: "testCache", type: .forecast, cacheTime: 1)
        
        XCTAssertNil(cachedData)
        
        cachedData = Cache.data(for: "testCache", type: .forecast, cacheTime: 5)
        
        guard let cachedData1 = cachedData else {
            
            XCTFail()
            return
        }
        let decodedText = String(data:cachedData1, encoding: .utf8)
        
        XCTAssertEqual(text, decodedText)

    }
}
