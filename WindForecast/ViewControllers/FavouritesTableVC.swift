//
//  FavouritesTableVC.swift
//  WindForecast
//
//  Created by MacBook Pro on 18.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import UIKit

final class FavouritesTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    var cities = [String]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cities = Favourites.favouriteCities()
        reloadTable()
    }
    
    private func reloadTable() {
        
        noDataView.isHidden = cities.count > 0
        tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath)

        cell.textLabel?.text = cities[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = Navigator.viewController(for: .weather) as? WeatherVC else { return }
        vc.currentCity = cities[indexPath.row]
        vc.type = .show
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let city = cities[indexPath.row]
            cities.remove(at: indexPath.row)
            Favourites.delete(city)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
