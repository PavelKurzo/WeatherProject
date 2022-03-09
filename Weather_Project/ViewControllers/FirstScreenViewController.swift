
import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameForCityTextField: UITextField!
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var collectionDataSource = CollectionDataSource()
    
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
    @IBAction func doOnTouchAddingButton(_ sender: Any) {
        self.collectionView.reloadData()
        
        if let inputCityName = nameForCityTextField.text, inputCityName.isEmpty == false {
            collectionDataSource.cities.append(CityNames(cityName: inputCityName))
        }

        nameForCityTextField.text = nil
        
        for cities in collectionDataSource.cities {
            
            collectionDataSource.weatherService.requestWeather(city: CityNames(cityName: "\(cities)")) { [ weak self] json, response in
                    
                }
            }
            
        }
    
    
    @IBAction func infoButton(_ sender: Any) {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            sender.endRefreshing()
            self.collectionView.reloadData()
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        collectionView.performBatchUpdates({
            collectionDataSource.removeDataFromCell(indexPath)
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SecondViewController = storyBoard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        SecondViewController.dataFromApii = collectionDataSource.weatherDataDictionary[indexPath]
        self.present(SecondViewController, animated: true, completion:nil)
        
        
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width - 25, height: view.frame.maxY / 8)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(10)
    }
}

extension UIView {
    func setGradient(for view: UIView, _ firstColor: UIColor, _ secondColor: UIColor)  {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            firstColor.cgColor,
            secondColor.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.9)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}






