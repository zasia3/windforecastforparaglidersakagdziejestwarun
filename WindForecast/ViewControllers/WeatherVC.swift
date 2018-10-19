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
    @IBOutlet weak var favouriteButton: UIButton!
    
    var type: WeatherVCType = .search
    
    var currentCity: String?
    
    var currentWind: Wind?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        speedLabel.text = "🌬️"
        
        updateView()
        loadWind()
    }
    
    private func updateView() {
        
        let hidden = type == .show
        
        searchView.isHidden = hidden
        favouriteButton.isHidden = hidden
        
        if let currentCity = currentCity {
            cityField.text = currentCity
        }
        
        if let currentWind = currentWind {
            speedLabel.text = "\(currentWind.speed) km/h"
        }
    }
    
    @IBAction func searchCity(_ sender: Any) {
        
        guard let cityName = cityField.text,
                !cityName.isEmpty else { return }
        
        currentCity = cityName
        loadWind()
    }
    
    @IBAction func addToFaourites(_ sender: Any) {
        guard let cityName = cityField.text,
            !cityName.isEmpty,
            let _ = currentWind else { return }
        
        Favourites.add(cityName)
    }
    
    private func loadWind() {
        guard let currentCity = currentCity else { return }
        
        WeatherLoader.wind(for: currentCity) { [weak self] (result) in
            switch result {
            case .success(let wind):
                
                self?.currentWind = wind
                
            case .failure(let error):
                self?.currentWind = nil
                self?.showAlert(for: error)
            }
            
            self?.updateView()
        }
    }
    
    func showAlert(for error: WeatherLoader.WeatherError) {
        
    }
}

