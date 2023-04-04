//
//  ViewController.swift
//  Clima
//
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {


    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManger = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        this line of code is saying is the textfield should report back to our view controller
        searchTextField.delegate = self
        weatherManger.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        if let secrectKey = Bundle.main.infoDictionary?["SECRECT_KEY"] as? String {
            print(secrectKey)
        }
    }


//    @IBAction func searchPressed(_ sender: UIButton) {
////        print(searchTextField.text!)
//        searchTextField.endEditing(true)
////        print(searchTextField.text!)
//    }
//    //since these delegate methods have default extension methods of UITextFieldDelegate protocol, that's the reason we didn't see any error even not implementing them, the defualt ones will be overrided if implement them
////    this is the function from the UITextFieldDelegate protocol, asking the delegate whether to process the pressing of return button for the text field, another words, telling view controller the user pressed the return key in the keyboard, what should we do
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        print(searchTextField.text!)
////        note this line of code will invoke textFieldDidEndEditing(), so searchTextField.text will changed accoding code block inside textFieldDidEndEditing
//        searchTextField.endEditing(true)
////        print(searchTextField.text!)
//        return true
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
////        here we use the generic textField instead of a spcific one
//        if textField.text != "" {
//            return true
//        }else{
//            textField.placeholder = "Type something"
//            return false
//        }
//    }
//
////    another delegate fucntion --  telling the view controller end editing triggered, what should we do
//    func textFieldDidEndEditing(_ textField: UITextField) {
////        Use searchTextField.text to get the weather for that city
//        if let city = searchTextField.text {
//            weatherManger.fetchWeather(cityName: city)
//        }
//        searchTextField.text = ""
//    }
    
//    func didUpdataWeather(weather: WeatherModel) {
//        conditionImageView.image = UIImage(named: weather.conditionName)
//        temperatureLabel.text = weather.temperatureString
//        cityLabel.text = weather.cityName
//    }
//    by comform to the apple naming convertions, update our didUpdataWeather() func as
//    func didUpdataWeather(_ weatherManager: WeatherManager,  weather: WeatherModel) {
//        DispatchQueue.main.async { [self] in
//            conditionImageView.image = UIImage(systemName: weather.conditionName)
//            temperatureLabel.text = weather.temperatureString
//            cityLabel.text = weather.cityName
//        }
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
}

//MARK: - UITextFieldDelegate

//refactor WeatherViewController with extension
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManger.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdataWeather(_ weatherManager: WeatherManager,  weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            conditionImageView.image = UIImage(systemName: weather.conditionName)
            temperatureLabel.text = weather.temperatureString
            cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
//        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("manageInfo:: \(manager)")
//        if locations.first != nil {
//            print("location:: \(locations)")
//        }
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            weatherManger.fetchWeather(latitude: lat, longitude: lon)
        }
    }
}
