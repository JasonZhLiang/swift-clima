//
//  WeatherModel.swift
//  Clima
//
//  Created by Jason Liang on 2023-03-28.
//

import Foundation
struct WeatherModel {
    //stored properties
    let conditionId: Int
    let cityName: String
    let temperature: Double
    //computed properties
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    var conditionName: String {
        switch conditionId{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun.fill"
        default:
            return "cloud"
        }
    }
}
