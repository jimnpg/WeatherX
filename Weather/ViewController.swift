//
//  ViewController.swift
//  Weather
//
//  Created by Grant Maloney on 9/17/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hourCollectionView: UICollectionView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var precipitationProbabilityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let days:[String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var collectionViewData: [CollectionViewData] = []
    
    var snow = false
    let snowFilter = Snow()
    
    let locManager = CLLocationManager()
    
    //TODO: Reload the view after the user confirms on location services
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.requestWhenInUseAuthorization()
            locManager.startUpdatingLocation()
        }
        
        var location: Location
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways) {

            if let currentLocation = locManager.location {
                print(currentLocation.coordinate.latitude)
                print(currentLocation.coordinate.longitude)
                location = Location(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude)
                
                fetchCityAndCountry(from: currentLocation) { city, country, error in
                    guard let city = city, let country = country, error == nil else { return }
                    
                    DispatchQueue.main.async {
                        self.navigationItem.title = city
                    }
                }
                
                location.getData() { city in
                    DispatchQueue.main.async {
                        self.currentTimeLabel.text = city.currentTime
                        self.sunsetLabel.text = city.sunset
                        self.sunriseLabel.text = city.sunrise
                        self.collectionViewData = city.collectionViewData
                        self.currentTemperatureLabel.text = city.currentTemperature
                        self.lowTemperatureLabel.text = city.lowTemperature
                        self.highTemperatureLabel.text = city.highTemperature
                        self.windSpeedLabel.text = city.windSpeed
                        self.windDirectionLabel.text = city.windDirection
                        self.precipitationProbabilityLabel.text = city.precipitationProbability
                        self.humidityLabel.text = city.humidity
                        self.hourCollectionView.reloadData()
                    }
                }
            }
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "List")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.showCities))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "World")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.toggleSnow))
        
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        //imageView.image = UIImage.gifImageWithURL("https://cdn.pbrd.co/images/HEMJg0u.gif")
        imageView.image = UIImage(named: "TestBackground")
        
        //Deciding if I want to show days at the bottom or not
        self.collectionView.isHidden = true
        
        self.collectionView.backgroundColor = UIColor.clear
        self.hourCollectionView.backgroundColor = UIColor.clear
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func showCities() {
        self.performSegue(withIdentifier: "showCities", sender: self)
    }
    
    @objc
    func toggleSnow() {
        snowFilter.handleSnow(toggle: snow, view: view)
        snow = !snow
    }
    
}

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ((collectionView as? HourCollectionView) != nil) {
            return 24 //24 hours in a day
        } else {
            return days.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if let view = collectionView as? HourCollectionView {
            let cell = view.dequeueReusableCell(withReuseIdentifier: "hourReuse", for: indexPath)
            if let cell = cell as? HourCell {
                cell.updateCell(cellForItemAt: indexPath, collectionViewData: collectionViewData)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuse", for: indexPath)
            if let cell = cell as? DayCell {
                cell.updateCell(cellForItemAt: indexPath, days: days)
            }
            return cell
        }
    }
}

func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
        completion(placemarks?.first?.locality,
                   placemarks?.first?.country,
                   error)
    }
}
