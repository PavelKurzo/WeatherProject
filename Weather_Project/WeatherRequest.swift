
import UIKit

struct CityNames {
    let cityName: String
}

class WeatherService {
    
    
    private let baseUrl = "api.openweathermap.org/data/2.5/"
    private let appid = "0058adaff3893eb760cbbf2c877c6e7d"
    
    
    private func makeUrl(_ method: String, parameter: [URLQueryItem]) -> URL? {
        var component = URLComponents()
        
        component.scheme = "https"
        component.path = baseUrl + method
        
        var queryItems = [
            URLQueryItem(name: "appid", value: appid)
        ]
        queryItems.append(contentsOf: parameter)
        
        component.queryItems = queryItems
        return component.url
    }
    
    func requestWeather(city: CityNames, completionHandler: ((String, WeatherResponse) -> Void)?) {
        
        let parameters = [
            URLQueryItem(name: "q", value: city.cityName),
            URLQueryItem(name: "lang", value: "eng"),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let weatherURL = makeUrl("weather", parameter: parameters) else { return }
        
        var request = URLRequest(url: weatherURL)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let data = data, let dataString = String(data: data, encoding: .utf8),
               let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                
                DispatchQueue.main.async {
                    completionHandler?(dataString, weatherResponse)
                }
                
            }
        }
        task.resume()
    }
    
}
