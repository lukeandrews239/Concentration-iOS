//
//  Weather.swift
//  ConcentrationGame
//
//  Created by Luke Andrews on 6/18/19.
//  Copyright © 2019 Luke Andrews. All rights reserved.
//

import Foundation

struct Weather {
    // City of Interest for our API request
    let city : String
    
    // Data we intend to grab from the JSON retrieved (Temp + Description)
    let temp : Double
    let desc : String
    
    // Sign up for your own key at https://www.apixu.com :). Free key gets 10,000 requests a month!
    // This one is easy because you can just append the city name you want to the end of the requestPath!
    static let requestPath = "https://api.apixu.com/v1/current.json?key=ea645929f9cb46188e003401191906&q="
    
    // Enum to specify errors
    enum WeatherError: Error {
        // Can have more specific cases for more specific errors (often correlate with API errors)
        case invalid(String)
    }
    
    init(dictFromJSON : [String : Any], cityOfInterest : String) throws {
        guard let temp = dictFromJSON["temp_f"] as? Double else {
            throw WeatherError.invalid("Something went wrong!")
        }
        guard let descDict = dictFromJSON["condition"] as? [String : Any] else {
            throw WeatherError.invalid("Something went wrong!")
        }
        guard let description = descDict["text"] as? String else {
            throw WeatherError.invalid("Something went wrong!")
        }
        
        self.temp = temp
        self.desc = description
        self.city = cityOfInterest
    }
    
    // Making the request
    static func getWeatherFromWeb(forCity city: String, completion: @escaping (Weather) -> ()) {
        let link = requestPath + city
        let request = URLRequest(url: URL(string: link)!)
        
        var ret : Weather? = nil
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, _, _) in
            if let data = data {
                do {
                    if let allData = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        if let todaysData = allData["current"] as? [String : Any] {
                            if let new = try? Weather(dictFromJSON: todaysData, cityOfInterest: city) {
                                ret = new
                            } else {
                                throw WeatherError.invalid("Something went wrong!")
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(ret!)
            }
        }
        task.resume()
    }
}





























