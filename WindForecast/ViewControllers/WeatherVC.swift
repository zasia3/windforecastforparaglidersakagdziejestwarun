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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    var type: WeatherVCType = .search
    
    var currentCity: String?
    
    var windForecasts: Forecast?

    override func viewDidLoad() {
        super.viewDidLoad()
        speedLabel.text = "Wind speed: 🌬️"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        
        updateView()
        loadWind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateImage()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func updateView() {
        
        searchView.isHidden = type == .show
        
        if let currentCity = currentCity {
            cityField.text = currentCity
            title = currentCity
        }
        
        guard let forecast = windForecasts,
                forecast.windForecasts.count > 0 else { return }
        
        let first = forecast.windForecasts[0]
        speedLabel.text = "Wind speed: \(first.wind.speed) km/h"
        directionLabel.text = "Wind direction: \(first.wind.symbol)"
        
        updateImage()
        
        guard forecast.windForecasts.count > 1 else { return }
        
        for i in 1..<forecast.windForecasts.count {
            let forecast = forecast.windForecasts[i]
            let label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "\(forecast.dt_txt) \nwind speed \(forecast.wind.speed) km/h \(forecast.wind.emoji)"
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
    }
    
    private func updateImage() {
        
        guard let wind = windForecasts?.windForecasts.first?.wind else { return }
        image.count = 8
        image.boldOrder = wind.index
        image.setNeedsDisplay()
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
            let _ = windForecasts else { return }
        
        Favourites.add(cityName.uppercased())
    }
    
    private func loadWind() {
        guard let currentCity = currentCity else { return }
        
        let force = type == .search
        
        WeatherLoader.windForecast(for: currentCity, force: force) { [weak self] (result) in
            switch result {
            case .success(let forecast):
                
                self?.windForecasts = forecast
                
                
            case .failure(let error):
                self?.windForecasts = nil
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

