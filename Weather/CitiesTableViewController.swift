//
//  CitiesTableViewController.swift
//  Weather
//
//  Created by Grant Maloney on 9/19/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import CoreData
import ForecastIO

class CitiesTableViewController: UITableViewController {

    var cities:[CityData] = []
    var coreCityData:[NSManagedObject] = []
    var cityTableViewData:[CityTableViewData] = []
    var offline: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
        self.view.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        extendedLayoutIncludesOpaqueBars = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.searchController?.searchBar.isHidden = true
        
        coreCityData = []
        cities = []
        cityTableViewData = []
        
        let (myCities, myCoreCityData) = GeoData.fetchData(entityName: "CityDataObject")
        coreCityData = myCoreCityData
        cities = myCities
        
        let myGroup = DispatchGroup()
        
        //Just as a note, in the future, may want to optimize this so that we make less calls to the API to save more money!
        for city in cities {
            myGroup.enter()

            if !self.offline{
                if let name = city.name {
                    if let subcountry = city.subcountry {
                        Location.getCoordinate(addressString: name) { (coordinate, error) in
                            let location = Location(lat: coordinate.latitude, lng: coordinate.longitude)
                            location.getData() { loc in
                                self.cityTableViewData.append(CityTableViewData(city: "\(name), \(subcountry)", currentTemperature: loc.currentTemperature, currentTime: currentTimeFormatter.string(from: loc.currentDate), icon: loc.collectionViewData.first?.icon))
                                myGroup.leave()
                            }
                        }
                    }
                }
            } else {
                if let name = city.name {
                    if let subcountry = city.subcountry {
                        self.cityTableViewData.append(CityTableViewData(city: "\(name), \(subcountry)", currentTemperature: "--", currentTime: "--", icon: Icon.clearDay))
                        myGroup.leave()
                    }
                }
            }
        }
        
        myGroup.notify(queue: .main) {
            let order = self.cities.map { "\($0.name!), \($0.subcountry!)" }
            let tempArray = self.cityTableViewData
            self.cityTableViewData = tempArray.reordered(defaultOrder: order)
            //self.newCity = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override open var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityTableViewData.count + 1
    }

    @objc
    func add() {
        self.performSegue(withIdentifier: "showSearch", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityReuse", for: indexPath)
    
        if let cell = cell as? CityTableViewCell {
            if self.cityTableViewData.count == indexPath.row {
                cell.cityLabel.text = ""
                cell.cityTemperatureLabel.text = ""
                cell.countryLabel.text = ""
                cell.weatherImage.isHidden = true
                cell.addButton.isHidden = false
                cell.selectionStyle = .none
                cell.addButton.addTarget(self, action: #selector(self.add), for: .touchUpInside)
                cell.curveView.isHidden = true
            } else {
                if !self.cityTableViewData.isEmpty {
                    if let city = self.cityTableViewData[indexPath.row].city {
                        if let temperature = self.cityTableViewData[indexPath.row].currentTemperature {
                            if let time = self.cityTableViewData[indexPath.row].currentTime {
                                if let icon = self.cityTableViewData[indexPath.row].icon {
                                    cell.cityLabel.text = city
                                    cell.cityTemperatureLabel.text = "\(temperature)°"
                                    cell.countryLabel.text = time
                                    cell.weatherImage.isHidden = false
                                    cell.weatherImage?.image = UIImage(named: icon.rawValue)
                                    cell.addButton.isHidden = true
                                    cell.curveView.backgroundColor = UIColor(rgb: 0x72a6f9)
                                    cell.curveView.layer.cornerRadius = 5.0
                                    cell.curveView.isHidden = false
                                    cell.selectionStyle = .default
                                }
                            }
                        }
                    } else {
                        print("Can't find city name!")
                    }
                }
            }
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == cityTableViewData.count {
            return false
        }
        
        if cityTableViewData.count == 1 {
            return false
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(coreCityData[indexPath.row])
        
            if indexPath.row != 0 {
                if let cityName = cityTableViewData[indexPath.row].city {
                    if let replacementName = cityTableViewData[0].city {
                        GeoData.checkName(data: cityName, replacement: replacementName)
                    }
                }
            } else {
                if let cityName = cityTableViewData[indexPath.row].city {
                    if let replacementName = cityTableViewData[1].city {
                        GeoData.checkName(data: cityName, replacement: replacementName)
                    }
                }
            }
            
            cities.remove(at: indexPath.row)
            cityTableViewData.remove(at: indexPath.row)
            coreCityData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try managedContext.save()
            } catch {
                print("Failed to save!")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == cityTableViewData.count {
            return
        }
        
        if let city = cities[indexPath.row].name {
            if let state = cities[indexPath.row].subcountry {
                GeoData.saveData(entityName: "CurrentCity", data: "\(city), \(state)")
            }
        }
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}
