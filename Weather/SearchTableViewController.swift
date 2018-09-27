//
//  SearchTableViewController.swift
//  Weather
//
//  Created by Grant Maloney on 9/24/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCities = [CityData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.view.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Enter city name"
        self.navigationItem.searchController?.searchBar.isHidden = false
        self.navigationController?.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchReuse", for: indexPath)
        
        if let cell = cell as? SearchCell {
            let city: CityData
            if isFiltering() {
                city = filteredCities[indexPath.row]
            } else {
                city = GeoData.geoData[indexPath.row]
            }
            
            if let subcountry = city.subcountry {
                if let name = city.name {
                    if let country = city.country {
                        cell.cityName.text = "\(name), \(subcountry)"
                        cell.countryName.text = "\(country)"
                        cell.bgView.layer.cornerRadius = 3.0
                        cell.bgView.backgroundColor = UIColor(rgb: 0x72a6f9)
                    }
                }
            }
        }
        
        return cell
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCities = GeoData.geoData.filter({( city : CityData) -> Bool in
            if let name = city.name {
                return name.lowercased().contains(searchText.lowercased())
            } else {
                return false
            }
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCities.count
        }
        
        return GeoData.geoData.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        var givenCity: CityData
        
        if isFiltering() {
            givenCity = self.filteredCities[indexPath.row]
        } else {//Should get rid of this in the future! only use filtered data... looks cleaner
            givenCity = GeoData.geoData[indexPath.row]
        }
        
        if let navController = self.navigationController {
            if let name = givenCity.name {
                if let subcountry = givenCity.subcountry {
                    if GeoData.checkData(data: name) {
                        navController.popViewController(animated: true)
                        return
                    }
                    
                    let fullName = "\(name), \(subcountry)"
                    GeoData.saveData(entityName: "CurrentCity", data: fullName)
                }
            }
            
            GeoData.saveData(entityName: "CityDataObject", data: givenCity)
//            let citiesViewController = navController.viewControllers[1]
//            if let controller = citiesViewController as? CitiesTableViewController {
//                controller.newCity = true
//            }
            navController.popViewController(animated: true)
        }
    }
}


extension SearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.searchController?.searchBar.isHidden = true
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
