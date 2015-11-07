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
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var tempSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherDetailsForCity()
        
    }
    
    @IBAction func tempTypeChanged(sender: UISegmentedControl) {
        updateUILabels()
    }
    
    
    func updateUILabels() {
        if let cityWeatherData = cityWeatherData {
            cityLabel.text = cityWeatherData.cityName
            currentTempLabel.text = tempByUserPreference(cityWeatherData.currentTemp)
            weatherDescriptionLabel.text = cityWeatherData.weatherDescription
            maxTempLabel.text = tempByUserPreference(cityWeatherData.maxTemp)
            lowTempLabel.text = tempByUserPreference(cityWeatherData.minTemp)
            humidityLabel.text = "\(cityWeatherData.humidity)%"
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
        WeatherAPIService.weatherByCity(city) { (cityWeatherData) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                self.cityWeatherData = cityWeatherData
                self.updateUILabels()
            }            
            print(cityWeatherData)
        }
        
    }
}
