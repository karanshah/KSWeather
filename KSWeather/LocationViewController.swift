//
//  LocationViewController.swift
//  KSWeather
//
//  Created by Karan Shah on 11/6/15.
//  Copyright © 2015 Karan Shah. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {
    
    enum LocationStatus {
        case Found(city: String)
        case Updating
        case Failed(message: String)
    }

    @IBOutlet var currentLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    var currentLocationStatus: LocationStatus = .Updating
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCurrentLabelButtonLabel()
        setupLocationManager()
    }
    
    @IBAction func viewCurrentLocationWeather(sender: UIButton) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let wdc = segue.destinationViewController as? WeatherDetailViewController where segue.identifier == "WeatherDetailSegue" {
            if case .Found(let city) = currentLocationStatus {
                wdc.city = city
            }
        }
    }
    
    func updateCurrentLabelButtonLabel() {
        let currentButtonText: String
        switch currentLocationStatus {
        case .Found(let cityString):
            currentButtonText = "View Weather for \(cityString)"
        case .Updating:
            currentButtonText = "Updating Current Location..."
        case .Failed(let failureMessage):
            currentButtonText = failureMessage
        }
        currentLocationButton.setTitle(currentButtonText, forState: .Normal)

    }
    
}

extension LocationViewController : CLLocationManagerDelegate {
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { [unowned self] (placemarks, error) -> Void in
            if error != nil {
                print(error)
                self.currentLocationStatus = .Failed(message: "Unable to find current Location")
                return
            }
            if let placemark = placemarks?.last {
                self.locationManager.stopUpdatingLocation()
                if let city = placemark.locality {
                    self.currentLocationStatus = .Found(city: city)
                }
                self.currentLocationButton.titleLabel?.text = "View Weather for \(placemark.locality)"
//                WeatherAPIService.weatherByCity(placemark.locality ?? "")
                print(placemark.locality)
                print(placemark.country)
            }
            self.updateCurrentLabelButtonLabel()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        currentLocationStatus = .Failed(message: "Unable to find current Location")
        updateCurrentLabelButtonLabel()
        print(error)
    }
}
