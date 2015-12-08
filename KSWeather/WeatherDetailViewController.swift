//
//  WeatherDetailViewController.swift
//  KSWeather
//
//  Created by Karan Shah on 11/6/15.
//  Copyright © 2015 Karan Shah. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    var city = ""
    var cityWeatherData: CityWeather?
    
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var tempSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if city.characters.count > 0 {
            getWeatherDetailsForCity()
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if city.characters.count == 0 {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func tempTypeChanged(sender: UISegmentedControl) {
        updateUILabels()
    }
    
    @IBAction func closeWeatherDetails(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateUILabels() {
        if let cityWeatherData = cityWeatherData {
            title = cityWeatherData.cityName
            currentTempLabel.text = tempByUserPreference(cityWeatherData.currentTemp)
            weatherDescriptionLabel.text = cityWeatherData.weatherDescription
        }
    }
    
    func tempByUserPreference(kelvinTemp: Double) -> String {
        let tempText: String
        switch tempSegmentControl.selectedSegmentIndex {
        case 0:
            let fahrenheitTemp = kelvinTemp * 9/5 - 459.67
            tempText = "\(Int(fahrenheitTemp)) °F"
        case 1:
            let celciusTemp = kelvinTemp - 273.15
            tempText = "\(Int(celciusTemp)) °C"
        default:
            tempText = ""
        }
        return tempText
    }
    
    func getWeatherDetailsForCity() {
        do {
            try WeatherAPIService.weatherByCity(city) { (cityWeatherData) -> () in
                dispatch_async(dispatch_get_main_queue()) {
                    self.cityWeatherData = cityWeatherData
                    self.updateUILabels()
                }
            }
        } catch {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
}
