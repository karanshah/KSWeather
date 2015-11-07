//
//  WeatherAPIService.swift
//  KSWeather
//
//  Created by Karan Shah on 11/5/15.
//  Copyright © 2015 Karan Shah. All rights reserved.
//

import Foundation

struct WeatherAPIService {
    
    static let weatherQueryURLString = "http://api.openweathermap.org/data/2.5/weather?q="
    static let apiParamString = "&appid="
    static let apiKey = ""
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    static func weatherByCity(city: String, completion: (CityWeather) -> ()) {
        let urlPath = weatherQueryURLString + city + apiParamString + apiKey
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating Weather API Url")
            return
        }
        queryURL(endpoint) { (json) -> () in
            print(json)
            guard let cityName = json["name"] as? String,
                let main = json["main"],
                let humidity = main["humidity"] as? Int,
                let temp = main["temp"] as? Double,
                let minTemp = main["temp_min"] as? Double,
                let maxTemp = main["temp_max"] as? Double else { return }
            
            var weatherDescription = ""
            if let weatherObj = json["weather"], weatherDesc = weatherObj["description"] as? String {
                weatherDescription = weatherDesc
            }
            let cityWeather = CityWeather(cityName: cityName, humidity: humidity, currentTemp: temp, minTemp: minTemp, maxTemp: maxTemp, weatherDescription: weatherDescription)
            
            completion(cityWeather)

        }
    }
    
    static func queryURL(endpoint: NSURL, completion: (NSDictionary) -> ()) {
        let request = NSMutableURLRequest(URL:endpoint)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                guard let rawData = data else { throw JSONError.NoData }
                guard let json = try NSJSONSerialization.JSONObjectWithData(rawData, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                completion(json)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch {
                print(error)
            }
            }
        task.resume()
    }
    
    
}