//
//  WeatherManager.swift
//  Clima
//
//  Created by Alexandre Robaert on 06/04/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func weatherDidUpdateData(_ weatherManager: WeatherManager, _ weatherModel: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f80e6eaca8a1df11127b383fdf5ea69e&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(from city: String) {
        let urlString = "\(weatherURL)&q=\(city.folding(options: .diacriticInsensitive, locale: .current))".replacingOccurrences(of: " ", with: "%20")
        performRequest(from: urlString)
    }
    
    func fetchWeather(from location: CLLocation) {
        let urlString = "\(weatherURL)&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)".replacingOccurrences(of: " ", with: "%20")
        performRequest(from: urlString)
    }
    
    private func performRequest(from url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url,completionHandler: { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let dados = data {
                    if let weatherModel = parseJSON(with: dados) {
                        self.delegate?.weatherDidUpdateData(self, weatherModel)
                    }
                }
            })
            
            task.resume()
        }
    }
    
    private func parseJSON(with data: Data) -> WeatherModel? {
        do {
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            return WeatherModel(conditionId: UInt(weatherData.weather.first!.id), temperature: weatherData.main.temperatura, cityName: weatherData.name)
        }catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
