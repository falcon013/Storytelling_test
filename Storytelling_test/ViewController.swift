//
//  ViewController.swift
//  Storytelling_test
//
//  Created by Maria Paderina on 5/22/19.
//  Copyright © 2019 Maria Paderina. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationAnotherLabel: UILabel!
    @IBOutlet weak var locationOneMoreLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureAnotherLabel: UILabel!
    @IBOutlet weak var temperatureOneMoreLabel: UILabel!
    
    @IBOutlet weak var labelMultiCity: UILabel!
    
    @IBOutlet weak var tempMeasure: UILabel!
    
    var apiKey = "e72ca729af228beabd5d20e3b7749713"
    let apiBaseUrl = "http://api.openweathermap.org/data/2.5/"
    
    var activityIndicator : NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    let citiesArray = [524901,703448,2643743]


    override func viewDidLoad() {
        super.viewDidLoad()
        let indicatorSize : CGFloat = 70
        let indicatorFrame = CGRect (x: (view.frame.width - indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        getWeatherMultipleCities(baseApiUrl: apiBaseUrl, apiKey: apiKey, unit: "metric", cities: citiesArray)
    }
    
    
    @IBAction func tempSwitchButton(_ sender: UISwitch) {
        if sender.isOn == true {
            tempMeasure.text = "℃"
            getWeatherMultipleCities(baseApiUrl: apiBaseUrl, apiKey: apiKey, unit: "metric", cities: citiesArray)
            
        } else {
            tempMeasure.text = "℉"
            getWeatherMultipleCities(baseApiUrl: apiBaseUrl, apiKey: apiKey, unit: "imperial", cities: citiesArray)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
            self.locationManager.stopUpdatingLocation()
        }
    
        func   locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print (error.localizedDescription)
    
        }

    func getWeatherMultipleCities(baseApiUrl: String, apiKey: String, unit: String, cities: [Int]) -> Void {
        let citiesList = (cities.map{String($0)}).joined(separator: ",")
        let apiUrl =  "\(baseApiUrl)group?id=\(citiesList)&units=\(unit)&appid=\(apiKey)"
        print (apiUrl)
        self.labelMultiCity.text = ""
        
        Alamofire.request(apiUrl).responseJSON{ response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                
                let listJson = jsonResponse["list"]
                
                for l in listJson.array!{
                    let cityName = l["name"].stringValue
                    let tempValue = l["main"]["temp"].intValue
                    self.labelMultiCity.text? += "\(cityName): \(tempValue)\n"
                }
                
                self.locationLabel.text = jsonResponse["list"][0]["name"].stringValue
                self.temperatureLabel.text = String(jsonResponse["list"][0]["main"]["temp"].intValue)
             
                
                self.locationOneMoreLabel.text = jsonResponse["list"][1]["name"].stringValue
                self.temperatureOneMoreLabel.text = String(jsonResponse["list"][1]["main"]["temp"].intValue)
                
                self.locationAnotherLabel.text = jsonResponse["list"][2]["name"].stringValue
                self.temperatureAnotherLabel.text = String(jsonResponse["list"][2]["main"]["temp"].intValue)
            }
        }
    }
    
            
    
}

    
    
    
    
    



