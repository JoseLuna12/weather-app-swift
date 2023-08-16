//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let weatherManager: WeatherManager = WeatherManager()
    let lManager = CLLocationManager()
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lManager.delegate = self
        lManager.requestWhenInUseAuthorization()
        lManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        lManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func searchAction(_ value: String){
        weatherManager.requestWeather(value)
        searchTextField.endEditing(true)
    }
    
    func getTextFieldValue(field: UITextField) -> String?{
        return searchTextField.text
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        if let value = getTextFieldValue(field: searchTextField) {
            searchAction(value)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            textField.placeholder = "Please Type A City Name"
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("returning")
        if let value  = getTextFieldValue(field: textField){
            searchAction(value)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func updateUI(weatherManager: WeatherManager, _ weather: WeatherModel) {
        print("delegate is working")
        print(weather.stringTemperature)
        DispatchQueue.main.async() {
            self.temperatureLabel.text = weather.stringTemperature
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let lastLocation = locations.last {
            lManager.stopUpdatingLocation()
            let lat = lastLocation.coordinate.latitude
            let long = lastLocation.coordinate.longitude
            
            weatherManager.requestWeather(latitude: lat, longitud: long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
