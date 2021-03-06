//
//  WeatherData.swift
//  Clima
//
//  Created by Dixita Bhargava on 13/06/20.
//  Copyright © 2020 Dixita Bhargava. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
