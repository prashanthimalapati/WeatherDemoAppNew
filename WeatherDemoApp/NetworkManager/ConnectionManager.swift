//
//  ConnectionManager.swift
//  WeatherDemoApp
//
//  Created by prashanthi M on 01/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//


import Foundation


class ConnectionManager {
    
   private  let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/weather"
     let openWeatherMapAPIKey = "44ba71967eb861c44eda8b602c7506b8"
    
    func getWeather(city: String, finish: @escaping ((message:String, data:Data?)) -> Void){
        
        // This is a pretty simple networking task, so the shared session will do.
        //    let session = URLSession.shared
        let weatherRequestURL = NSURL(string:"\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let request = URLRequest(url: weatherRequestURL! as URL)
        // The data task retrieves the data.
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                print("Raw data:\n\(data!)\n")
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                print("Human-readable data:\n\(dataString!)")
                result.message = "Success"
                               result.data = dataString?.data(using: .utf8)
                               finish(result)
            }
            
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
}
