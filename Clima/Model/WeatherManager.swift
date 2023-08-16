//
//  WeatherManager.swift
//  Clima
//
//  Created by Jose Luna on 30/9/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func updateUI(weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=79d25ae0d42a07dfede07dbff8d33fa2&units=metric"
    
    func requestWeather(_ city: String){
        let url = "\(weatherUrl)&q=\(city)"
        performRequest(with: url)
    }
    
    func requestWeather(latitude lat: CLLocationDegrees, longitud lon: CLLocationDegrees){
        let url = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){
                (data: Data?, response: URLResponse?, err: Error?) in
                if let e = err {
                    self.delegate?.didFailWithError(error: e)
                    return
                }
                
                if let d = data {
                    print(d)
                    if let weather = self.parseJson(with: d) {
                        self.delegate?.updateUI(weatherManager: self, weather)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJson(with data: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
