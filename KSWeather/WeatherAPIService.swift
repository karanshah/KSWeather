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
    
    static func weatherByCity(city: String) {
        let urlPath = weatherQueryURLString + city + apiParamString + apiKey
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating Weather API Url")
            return
        }
        queryURL(endpoint) { (json) -> () in
            guard let main = json["main"], let maxTemp = main["temp_max"] else { return }
            print(maxTemp)
            print(json)
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