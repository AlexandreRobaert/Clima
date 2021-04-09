//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var principalStack: UIStackView!
    
    var managerWeather = WeatherManager()
    let managerLocation = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        managerWeather.delegate = self
        
        managerLocation.delegate = self
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(false)
    }
    
    @IBAction func pressedLocation(_ sender: UIButton){
        managerLocation.requestLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.managerLocation.stopUpdatingLocation()
            self.managerWeather.fetchWeather(from: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - UITextViewDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text!.count > 3 {
            textField.endEditing(false)
            return true
        }
        
        textField.text = ""
        textField.placeholder = "Você deve inserir uma cidade aqui"
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text!.count > 3 {
            return true
        }
        textField.placeholder = "Você deve inserir uma cidade aqui."
        textField.text = ""
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cidade = textField.text else { return }
        managerWeather.fetchWeather(from: cidade)
        textField.placeholder = "Search"
        textField.text = ""
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func weatherDidUpdateData(_ weatherManager: WeatherManager, _ weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(format: "%.1f", weatherModel.temperature)
            self.cityLabel.text = weatherModel.cityName
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            self.principalStack.isHidden = false
            self.cityLabel.isHidden = false
            self.conditionImageView.isHidden = false
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.temperatureLabel.text = "0"
            self.conditionImageView.image = UIImage(systemName: "togglepower")
            self.cityLabel.text = "Cidade não encontrada!"
        }
    }
}
