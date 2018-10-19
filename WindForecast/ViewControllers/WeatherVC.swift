//
//  WeatherVC.swift
//  WindForecast
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import UIKit

enum WeatherVCType {
    case search
    case show
}

final class WeatherVC: UIViewController {
    
    @IBOutlet weak var searchView: UIStackView!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var image: UIView!
    
    var type: WeatherVCType = .search
    
    var currentWind: Wind? {
        didSet {
            guard let wind = currentWind else { return }
    
            speedLabel.text = "\(wind.speed) km/h"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        searchView.isHidden = type == .show
    }
    
    @IBAction func searchCity(_ sender: Any) {
        
        guard let cityName = cityField.text,
        !cityName.isEmpty
        else { return }
        
        WeatherLoader.wind(for: cityName) { [weak self] (result) in
            switch result {
            case .success(let wind):
                
                self?.currentWind = wind
                
            case .failure(let error):
                
                self?.showAlert(for: error)
            }
        }
    }
    @IBAction func addToFaourites(_ sender: Any) {
        guard let cityName = cityField.text,
            !cityName.isEmpty,
            let _ = currentWind else { return }
        
        Favourites.add(cityName)
    }
    
    func showAlert(for error: WeatherLoader.WeatherError) {
        
    }
}

