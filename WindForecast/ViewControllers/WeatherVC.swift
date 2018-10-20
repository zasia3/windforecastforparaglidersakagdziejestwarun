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
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var image: WindView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var type: WeatherVCType = .search
    
    var currentCity: String?
    
    var currentWind: Wind?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        speedLabel.text = "Wind speed: 🌬️"
        
        updateView()
        loadWind()
    }
    
    private func updateView() {
        
        let hidden = type == .show
        
        searchView.isHidden = hidden
        favouriteButton.isHidden = hidden
        
        if let currentCity = currentCity {
            cityField.text = currentCity
            title = currentCity
        }
        
        if let currentWind = currentWind {
            speedLabel.text = "Wind speed: \(currentWind.speed) km/h"
            directionLabel.text = "Wind direction: \(currentWind.symbol)"
            updateImage(for: currentWind.index)
        }
    }
    
    private func updateImage(for directionIndex: Int?) {
        image.drawArrows(count: 8, boldOrder: directionIndex)
        image.layoutIfNeeded()
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
        
        Favourites.add(cityName.uppercased())
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
        
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

