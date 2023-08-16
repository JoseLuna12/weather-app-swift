//
//  WeatherData.swift
//  Clima
//
//  Created by Jose Luna on 3/10/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData: Decodable {
    var name: String
    var main: Main
    var weather: [Weather]
}

struct Main: Decodable {
    var temp: Double
}

struct Weather: Decodable {
    var id: Int
}
