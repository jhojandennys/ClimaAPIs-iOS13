//
//  WeatherViewController.swift
//  Clima
//
//  Created by Jhojan Sobrino on 20/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {

    let locationManager = CLLocationManager()
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weathermanager = WeatherManage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weathermanager.delegate = self
        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func ButtonLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}
//MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate
{
    @IBAction func searchPressed(_ sender:UIButton){
        searchTextField.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)-> Bool{
        if textField.text == ""{
            textField.placeholder = "Is empty"
            return false
        }
        else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if let city = searchTextField.text {
            weathermanager.fetchWeatherApi(cityName: city)
        }
       
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    
    func didUpdateWeather(_ weatherManager: WeatherManage,weather: WeatherModel){
        print(weather.temperature)
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}

extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
          
            weathermanager.fetchWeatherApiLatiLon(latitude: lat,longitude:lon)
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
