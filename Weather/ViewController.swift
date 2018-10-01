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
    @IBOutlet weak var loadingBackground: UIView!
    @IBOutlet weak var loadingImage: UIImageView!
    
    var timer: Timer?
    var loading: Timer?
    var currentDate = Date()
    
    let days:[String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var collectionViewData: [CollectionViewData] = []
    
    var snow = false
    let snowFilter = Snow()
    
    let locManager = CLLocationManager()
    
    let offline: Bool = false
    
    var latitude: Double?
    var longitude: Double?
    
    //TODO: Reload the view after the user confirms on location services
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.requestWhenInUseAuthorization()
            locManager.startUpdatingLocation()
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "List")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.showCities))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "World")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.radar))
        self.navigationController?.isToolbarHidden = true
        
        //Deciding if I want to show days at the bottom or not
        self.collectionView.isHidden = true
        self.collectionView.backgroundColor = UIColor.clear
        self.hourCollectionView.backgroundColor = UIColor.clear
        
        GeoData.loadGeoData()
        
        imageView.image = UIImage(named: "TestBackground3")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        loading = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.loadScreen), userInfo: nil, repeats: false)
    }
    
    @objc
    func loadScreen() {
        loading?.invalidate()
        loading = nil
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.loadingImage.alpha = 0.0
            self.loadingImage.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: {
            (finished: Bool) -> Void in
            
            self.loadingImage.isHidden = true
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.loadingBackground.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                self.loadingBackground.isHidden = true
            })
        })
    }
    
    @objc
    func reload() {
        let cityName:String = GeoData.fetchData(entityName: "CurrentCity")
        
        if cityName != "" {
            Location.getCoordinate(addressString: cityName) { (coordinate, error) in
                
                let location = Location(lat: coordinate.latitude, lng: coordinate.longitude)
                
                self.longitude = coordinate.longitude
                self.latitude = coordinate.latitude
                
                if !self.offline {
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
                            self.currentDate = city.currentDate
                            self.hourCollectionView.reloadData()
                        }
                    }
                }
            }
            
            self.navigationItem.title = cityName.components(separatedBy: ",").first
        }
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        NotificationCenter.default.removeObserver(self, name: nil, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationItem.searchController?.searchBar.isHidden = true
        }
        
        reload()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getTimeOfDate), userInfo: nil, repeats: true)
        
        self.navigationItem.searchController?.searchBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
        timer = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RadarViewController {
            if let lat = latitude {
                destination.latitude = lat
            }
            
            if let lng = longitude {
                destination.longitude = lng
            }
        }
    }

    @objc
    func radar() {
        self.performSegue(withIdentifier: "showRadar", sender: self)
    }
    
    @objc
    func showCities() {
        self.performSegue(withIdentifier: "showCities", sender: self)
    }
    
    @objc
    func getTimeOfDate() {
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .second, value: 1, to: currentDate) {
            currentTimeLabel.text = currentTimeFormatter.string(from: date)
            currentDate = date
        }
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
            
            if !collectionViewData.isEmpty {
                if indexPath.row == 0 && collectionViewData[indexPath.row].hour == "Now" && collectionViewData[indexPath.row].icon == .snow {
                    snow = true
                } else {
                    snow = false
                }
                snowFilter.handleSnow(toggle: snow, view: self.view)
            }
            
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
