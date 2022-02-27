
import Foundation
import UIKit

extension UIImageView { 
    func setImage(_ iconName: String?) {
        guard let iconName = iconName else {
            image = nil
            return
        }
        setImage(URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png"))
    }
    func setImage(_ url: URL?) {
        guard let url = url else {
            image = nil
            return
        }
        let downloadTask = URLSession.shared.dataTask(with: url) { [weak self] data, repsonse, error in
            DispatchQueue.main.async {
                if let data = data {
                    self?.image = UIImage(data: data)
                } else {
                    self?.image = nil
                }
            }
            
        }
        downloadTask.resume()
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
extension UIViewController {
    
    func ConfirmationAlertOk() {
        
        let confirmationAlert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let confirmationAction = (UIAlertAction(title: "Ok", style: .default, handler: { _ in print()}))
        confirmationAlert.addAction(confirmationAction)
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    func warningAlertDecline() {
        
        let warningAlert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let warningActionDecline = (UIAlertAction(title: "Warning", style: .default, handler: { _ in print()}))
        warningAlert.addAction(warningActionDecline)
        self.present(warningAlert, animated: true, completion: nil)
    }
}





