
import UIKit

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct WeatherConditions: Codable {
    let description: String
    let icon: String
}

struct MainConditions: Codable {
    typealias Temperature = Double
    let temp: Temperature
    let feels_like: Temperature
    let temp_min: Temperature
    let temp_max: Temperature
    let humidity: Int
}
struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [WeatherConditions]
    let main: MainConditions
    let name: String
}
