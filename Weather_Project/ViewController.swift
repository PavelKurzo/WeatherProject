

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameForCityTextField: UITextField!
    @IBOutlet weak var addingButton: UIButton!
    
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var collectionDataSource = CollectionDataSource()
    var value: WeatherResponseData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradient(for: view, .systemCyan, .white)
        configureCollectionView()
        configureTextfield()
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .primaryActionTriggered)
    }
    
    private func configureTextfield() {
        nameForCityTextField.backgroundColor = UIColor( red: CGFloat(153/255.0), green: CGFloat(204/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0))
        nameForCityTextField.tintColor  = .black
        
        
    }
    @IBAction func addingButton(_ sender: Any) {
        
        if let InputCityName = nameForCityTextField.text, InputCityName.isEmpty == false {
            collectionDataSource.cities.append(CityNames(cityName: InputCityName))
        }
        nameForCityTextField.text = nil
        
        for cities in collectionDataSource.cities {
            
            collectionDataSource.weatherService.requestWeather(city: CityNames(cityName: "\(cities)")) { [ weak self] json, response in
                self?.collectionView.reloadData()
            }
            
        }
    }
    
    @IBAction func InfoButton(_ sender: Any) {
        let alertViewController = UIAlertController(
            title: "Info",
            message: "To delete cell swipe left or rigth",
            preferredStyle: .alert
        )
        alertViewController.addAction(
            UIAlertAction(title: "Ok", style: .default, handler: { _ in print(#function) })
        )
        present(alertViewController, animated: true, completion: nil)
        
    }
    
    private func configureCollectionView() {
        
        collectionView.backgroundColor = .none
        collectionView.dataSource = collectionDataSource
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        
    }
    
    @objc private func handlePullToRefresh(_ sender: UIRefreshControl, _ indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.endRefreshing()
            self.collectionView.reloadData()
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        collectionDataSource.cities.remove(at: indexPath.row)
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.reloadItems(at: [indexPath])
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SecondViewController = storyBoard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        value = collectionDataSource.weatherDataDictionary[indexPath]
        SecondViewController.longtitude = value?.coordLong ?? 0.0
        SecondViewController.lantitude = value?.coordLat ?? 0.0
        SecondViewController.tempMax = value?.temp_max ?? 0.0
        SecondViewController.tempMin = value?.temp_min ?? 0.0
        SecondViewController.cityName = value?.nameOfTheCity ?? ""
        SecondViewController.humidity = value?.humidity ?? 0
        SecondViewController.cityTemprature = value?.temp ?? 0.0
        SecondViewController.feelsLike = value?.feels_like ?? 0.0
        self.present(SecondViewController, animated: true, completion:nil)
        
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 25, height: view.frame.maxY / 7)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(10)
    }
}






