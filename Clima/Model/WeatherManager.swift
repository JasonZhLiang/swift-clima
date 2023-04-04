//
//  WeatherManager.swift
//  Clima
//
//  Created by Jason Liang on 2023-03-26.
//

import Foundation
import CoreLocation

//we don't need the separate file for creating protocol, by swift convention, we create the protocol in the same file as the class/struct that will use the protocol
protocol WeatherManagerDelegate{
    func didUpdataWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=fc0d97294fa275ec8371a407db905d6b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    //instead of using double for the lat and lon type, we use the same type as getting from location.coordinate.latitude in VC
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
//    a variant of external and internal parameter name, instead of omit symbol _, we can use any other more meaningful word for external name
    func performRequest(with urlString: String){
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            // let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            // using closure instead
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString)
                    if let weather = parseJSON(safeData){
                        //we can do something like code below, but for a generic watherManager, we don't want it call any specific object, so that's delegate comes to play
//                        let weatherVc = WeatherViewController()
//                        weatherVc.didUpdataWeather(self, weather: weather)
                        //delegate?.didUpdataWeather(weather: weather)
                        //to reflect the changes of protocol didUpdataWeather()
                        delegate?.didUpdataWeather(self, weather: weather)
                    }
                }
            }
            //4.Start the task
            task.resume()
        }
    }
    //    //    so we don't need this handle method if using closure
    //        func handle(data: Data?, response: URLResponse?, error: Error?) {
    //            if error != nil {
    //                print(error!)
    //                return
    //            }
    //
    //            if let safeData = data {
    //                let dataString = String(data: safeData, encoding: String.Encoding.utf8)
    //                print(dataString)
    //            }
    //        }
    func parseJSON(_ weatherData: Data)-> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //            print(decodedData.name)
            //            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
            //            print(decodedData.weather[0].id)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
