//
//  ViewController.swift
//  Clima
//
//  Created by Dixita Bhargava on 13/06/20.
//  Copyright © 2020 Dixita Bhargava. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self

        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{

    //  IBAction for the search icon
        @IBAction func seachPressed(_ sender: UIButton) {
            searchTextField.endEditing(true)
           print(searchTextField.text!)
        }
        
    //    asks the delegate if the text feild should process the pressing of the reutn button
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true)
            print(searchTextField.text!)
            return true
        }
        
    //    checks if the text field is empty or not
    //    we use text feild bcos it refers to all the text feilds in the ui
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != ""{
                return true
            }
            else {
                textField.placeholder = "Type Something"
                return false
            }
        }
        
    //    resets the text feild to empty after the search is taken place
        func textFieldDidEndEditing(_ textField: UITextField) {
            //use searchTextField.text to get the weather for that city.
            if let city = searchTextField.text{
                weatherManager.fetchWeather(cityName: city)
            }
            searchTextField.text = ""
        }
    
    @IBAction func locationBtnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
       }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    //    updates weather
        func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
            }
        }
        
    //    for any errors
        func didFailWithError(error: Error) {
            print(error)
        }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
