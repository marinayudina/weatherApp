//
//  ViewController.swift
//  weather_app
//
//  Created by Марина on 24.08.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    private let backImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "background"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search"
        textField.backgroundColor = .systemFill
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 25)
        textField.autocapitalizationType = .words
        textField.returnKeyType = .go
        return textField
    }()
    
    private lazy var loopButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loopButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return button
    }()
    private lazy var searchStack = UIStackView(arrangedSubviews: [locationButton, searchField, loopButton], axis: .horizontal, spacing: 5)
    
    private let weatherImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.max")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let temp1Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "21"
        label.font = .systemFont(ofSize: 80, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let temp2Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°"
        label.font = .systemFont(ofSize: 80, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let temp3Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "C"
        label.font = .systemFont(ofSize: 80, weight: .bold)
        label.textColor = .black
        return label
    }()
    private lazy var labelsStack = UIStackView(arrangedSubviews: [temp1Label, temp2Label, temp3Label], axis: .horizontal, spacing: 0)
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "London"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
//        label.alig
        return label
    }()
    
    private lazy var mainStack = UIStackView(arrangedSubviews: [searchStack, weatherImage, labelsStack, cityLabel], axis: .vertical, spacing: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchField.delegate = self
        weatherManager.delegate = self
    }
    private func setupView() {
        view.addSubview(backImage)
        
        searchStack.distribution = .fill
        mainStack.alignment = .trailing
//        weatherImage.backgroundColor = .red
//        mainStack.backgroundColor = .black
//        cityLabel.backgroundColor = .systemPink
        labelsStack.distribution = .fill
        mainStack.distribution = .fill

        
        view.addSubview(mainStack)

    }
    
    @objc func locationButtonPressed(_ sender: UIButton){
        
        locationManager.requestLocation()
    }
    
    @objc func loopButtonPressed(_ sender: UIButton){
        searchField.endEditing(true) //dismiss keyboard
        print(searchField.text!)
    }

}

//MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: WeatherManagerDelegate{
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
//        print(weather.temperature)
        DispatchQueue.main.async {
            self.temp1Label.text = weather.temperatureString
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        print(searchField.text!)
        return true
    }
    //user type somewhere else
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type sth here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchField.text = ""
    }
    

}

extension ViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backImage.topAnchor.constraint(equalTo: view.topAnchor),
            
//            searchStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            searchStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            
            loopButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            
            weatherImage.heightAnchor.constraint(equalToConstant: 100),
            weatherImage.widthAnchor.constraint(equalToConstant: 100),

            
            
            mainStack.heightAnchor.constraint(equalTo: view.heightAnchor,
                                              multiplier: 0.37),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}


