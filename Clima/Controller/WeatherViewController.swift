//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

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
        textField.placeholder = "Search"
        textField.text = ""
    }
}
