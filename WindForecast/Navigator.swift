//
//  Navigator.swift
//  WindForecast
//
//  Created by MacBook Pro on 19.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import UIKit

struct Navigator {
    
    enum ViewControllers {
        case weather
    }
    
    static func viewController(for type: ViewControllers) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch type {
            case .weather:
                return storyboard.instantiateViewController(withIdentifier: "WeatherVC")
        }
    }
}
