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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherDetailsForCity()
        
    }
    
    func getWeatherDetailsForCity() {
        WeatherAPIService.weatherByCity(city) { (cityWeatherData) -> () in
            print(cityWeatherData)
        }
        
    }
}
