//
//  WeatherManage.swift
//  Clima
//
//  Created by Jhojan Sobrino on 20/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManage,weather:WeatherModel)
    func didFailWithError(error : Error)
}
struct WeatherManage{
    let URL = "https://api.openweathermap.org/data/2.5/weather?appid=da5a6ba5ea00fed044fc54274f2dd9f0&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    
    func fetchWeatherApi(cityName:String){
        let url = "\(URL)&q=\(cityName)"
        performRequest(url: url)
    }
    
   func fetchWeatherApiLatiLon(latitude: CLLocationDegrees,longitude:CLLocationDegrees){
        let url = "\(URL)&lat=\(latitude)&lon=\(longitude)"
       performRequest(url: url)
    }
    
    func performRequest(url:String){
        if let url = Foundation.URL(string:url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handler(data: response: error: ))
            //START
            task.resume()
        }
    }
    
    func handler(data: Data?,response:URLResponse?,error:Error?)->Void{
        if error != nil{
            delegate?.didFailWithError(error: error!)
            return
        }
        if let unwrData = data {
            if let weather = parseJSON(weatherData: unwrData){
                self.delegate?.didUpdateWeather(self, weather: weather)
            }
        }
        
    }
    
    func parseJSON(weatherData:Data)->WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decoderData.weather[0].id
            let temp = decoderData.main.temp
            let name = decoderData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.temperatureString)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
