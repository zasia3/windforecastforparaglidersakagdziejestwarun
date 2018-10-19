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
        
        WeatherLoader.wind(for:""){ (result) in
            
            if case .error(_) = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testRequest() {
        let expect = expectation(description: #function)
        
        WeatherLoader.wind(for:"Leeds"){ (result) in
            
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
}
