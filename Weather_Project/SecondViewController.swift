

import UIKit
import CoreLocation
import MapKit

class SecondViewController: UIViewController {
    
    private lazy var locationManager = CLLocationManager()
    private lazy var mapView = MKMapView()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTemptaruteLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var backMenuButton: UIButton!
    
    var cityTemprature: Double = 0.0
    var humidity: Int = 0
    var feelsLike: Double = 0.0
    var cityName: String = ""
    var longtitude: Double = 0.0
    var lantitude: Double = 0.0
    var tempMin: Double = 0.0
    var tempMax: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.pinToEdges(view)
        configureMap()
        configureLabels()
    }
    private func configureLabels() {
        tempMaxLabel.text = "Max temp \(tempMax) °C"
        tempMinLabel.text = "Min temp \(tempMin) °C"
        feelsLikeLabel.text = "Feels like \(feelsLike) °C"
        cityNameLabel.text = "\(cityName)"
        cityTemptaruteLabel.text = "\(cityTemprature)°C"
        humidityLabel.text = "Humidity \(humidity) %"
    }
    
    private func configureMap() {
        mapView.showsUserLocation = true
        let coordinate = CLLocationCoordinate2DMake(lantitude, longtitude)
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        mapView.setCamera(MKMapCamera(lookingAtCenter: coordinate,
                                      fromDistance: 50_000,
                                      pitch: 45,
                                      heading: 200),
                          animated: true)
        
    }
    
}

extension UIView {
    
    func pinToEdges(_ view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 2),
                bottomAnchor.constraint(equalTo: view.bottomAnchor),
                leftAnchor.constraint(equalTo: view.leftAnchor),
                rightAnchor.constraint(equalTo: view.rightAnchor),
            ]
        )
        
    }
    
}
extension SecondViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        mapView.setCenter(location.coordinate, animated: true)
        mapView.setCamera(MKMapCamera(lookingAtCenter: location.coordinate,
                                      fromDistance: 100_000,
                                      pitch: 45,
                                      heading: 200),
                          animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}




