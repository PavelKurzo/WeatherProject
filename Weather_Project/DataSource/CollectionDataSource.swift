
import UIKit


struct WeatherResponseData {
    
    let coordLong: Double
    let coordLat: Double
    var nameOfTheCity: String
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
    let feels_like: Double
}

class CollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var weatherDataDictionary: [IndexPath : WeatherResponseData] = [:]
    var weatherService = WeatherService()
    var cities: [CityNames] = [
        CityNames(cityName: "Warsaw"),
        CityNames(cityName: "London"),
        CityNames(cityName: "Minsk"),
        CityNames(cityName: "Bangkok"),
        CityNames(cityName: "Lagos"),
        CityNames(cityName: "Madrid"),
        CityNames(cityName: "Moscow"),
        CityNames(cityName: "Berlin")
    ]
    
    func removeDataFromCell(_ indexPath: IndexPath) {
        cities.remove(at: indexPath.row)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        
        cell.backgroundColor = UIColor(white: 0.6, alpha: 0.2)
        cell.layer.cornerRadius = 15
        
        if let cell = cell as? MyProgCell {
            
            weatherService.requestWeather(city: cities[indexPath.row]) { [ weak self] json, response in
                let formatted = String(format: "%.0f", response.main.temp)
                cell.tempratureLabel.text = "\(formatted)°C"
                cell.conditionLabel.text = response.weather.first?.description
                cell.locationLabel.text = response.name
                cell.iconImageView.setImage(response.weather.first?.icon)
                
                self?.weatherDataDictionary[indexPath] = WeatherResponseData.init(coordLong: response.coord.lon, coordLat: response.coord.lat, nameOfTheCity: response.name, temp: response.main.temp, temp_min: response.main.temp_min, temp_max: response.main.temp_max, humidity: response.main.humidity, feels_like: response.main.feels_like)
            }
        }
        return cell
    }
}

