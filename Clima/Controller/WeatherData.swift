//
//  WeatherData.swift
//  Clima
//
//  Created by Jhojan Sobrino on 20/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation


struct WeatherData :Codable{
    let name : String
    let main : Main
    let weather: [Weather]
}
