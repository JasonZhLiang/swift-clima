//
//  WeatherData.swift
//  Clima
//
//  Created by Jason Liang on 2023-03-28.
//

import Foundation
//make sure all porperty names mathc the names of the keys in JSON data precisely
struct WeatherData: Codable {
    let name: String
    let id: Int
    let main: Main
    let weather: [Weather] // wrap the weather struct as array to match json weather
}
//Codable is a typealias, equal to Decodable & Encodable
struct Main: Decodable, Encodable{
    let temp: Double
    let pressure: Float
}

struct Weather: Codable {
    let description: String
    let id: Int
}
