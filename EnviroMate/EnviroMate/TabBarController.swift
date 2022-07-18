//
//  TabBarController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 6/28/22.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var prevSearch = ""
    var reqLat = 0.00
    var reqLon = 0.00
    var reqCity = ""
    var reqState = ""
    var reqAddr = "None"
    
    // dictionary that will hold all of the environmental attributes from the api request
    var locAttrs: [String:Any] = [:]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set the default tab bar item that is selected
        // to the weather item (item 2 where index starts at 0)
        self.selectedIndex = 2
        
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == tabBarController.viewControllers![0] {
            if(reqCity != "") {
                (viewController as! AirQualityContentViewController).airQualCityLabel.text = reqCity
            }
            
            if(reqState != "") {
                (viewController as! AirQualityContentViewController).airQualStateLabel.text = reqState
            }
            
            if(reqAddr != "None") {
                (viewController as! AirQualityContentViewController).airQualAddrLabel.text = reqAddr
            }
            
            if(reqLat != 0.00) {
                (viewController as! AirQualityContentViewController).airQualLatLabel.text = "Lat: " + String(reqLat)
            }
            
            if(reqLon != 0.00) {
                (viewController as! AirQualityContentViewController).airQualLonLabel.text = "Lon: " + String(reqLon)
            }
            
            if(prevSearch != "") {
                (viewController as! AirQualityContentViewController).airQualLocTextField.text = prevSearch
            }
        } else if(viewController == tabBarController.viewControllers![1]) {
            if(reqCity != "") {
                (viewController as! PlantContentViewController).plantCityLabel.text = reqCity
            }
            
            if(reqState != "") {
                (viewController as! PlantContentViewController).plantStateLabel.text = reqState
            }
            
            if(reqAddr != "None") {
                (viewController as! PlantContentViewController).plantAddrLabel.text = reqAddr
            }
            
            if(reqLat != 0.00) {
                (viewController as! PlantContentViewController).plantLatLabel.text = "Lat: " + String(reqLat)
            }
            
            if(reqLon != 0.00) {
                (viewController as! PlantContentViewController).plantLonLabel.text = "Lon: " + String(reqLon)
            }
            
            if(prevSearch != "") {
                (viewController as! PlantContentViewController).plantLocTextField.text = prevSearch
            }
        } else if(viewController == tabBarController.viewControllers![2]) {
            if(reqCity != "") {
                (viewController as! WeatherContentViewController).weatherCityLabel.text = reqCity
            }
            
            if(reqState != "") {
                (viewController as! WeatherContentViewController).weatherStateLabel.text = reqState
            }
            
            if(reqAddr != "None") {
                (viewController as! WeatherContentViewController).weatherAddrLabel.text = reqAddr
            }
            
            if(reqLat != 0.00) {
                (viewController as! WeatherContentViewController).weatherLatLabel.text = "Lat: " + String(reqLat)
            }
            
            if(reqLon != 0.00) {
                (viewController as! WeatherContentViewController).weatherLonLabel.text = "Lon: " + String(reqLon)
            }
            
            if(prevSearch != "") {
                (viewController as! WeatherContentViewController).weatherLocTextField.text = prevSearch
            }
        } else if(viewController == tabBarController.viewControllers![3]) {
            if(reqCity != "") {
                (viewController as! FireWaterContentViewController).fireWaterCityLabel.text = reqCity
            }
            
            if(reqState != "") {
                (viewController as! FireWaterContentViewController).fireWaterStateLabel.text = reqState
            }
            
            if(reqAddr != "None") {
                (viewController as! FireWaterContentViewController).fireWaterAddrLabel.text = reqAddr
            }
            
            if(reqLat != 0.00) {
                (viewController as! FireWaterContentViewController).fireWaterLatLabel.text = "Lat: " + String(reqLat)
            }
            
            if(reqLon != 0.00) {
                (viewController as! FireWaterContentViewController).fireWaterLonLabel.text = "Lon: " + String(reqLon)
            }
            
            if(prevSearch != "") {
                (viewController as! FireWaterContentViewController).fireWaterLocTextField.text = prevSearch
            }
        } else if(viewController == tabBarController.viewControllers![4]) {
            if(reqCity != "") {
                (viewController as! SoilContentViewController).soilCityLabel.text = reqCity
            }
            
            if(reqState != "") {
                (viewController as! SoilContentViewController).soilStateLabel.text = reqState
            }
            
            if(reqAddr != "None") {
                (viewController as! SoilContentViewController).soilAddrLabel.text = reqAddr
            }
            
            if(reqLat != 0.00) {
                (viewController as! SoilContentViewController).soilLatLabel.text = "Lat: " + String(reqLat)
            }
            
            if(reqLon != 0.00) {
                (viewController as! SoilContentViewController).soilLonLabel.text = "Lon: " + String(reqLon)
            }
            
            if(prevSearch != "") {
                (viewController as! SoilContentViewController).soilLocTextField.text = prevSearch
            }
        }
    }
    
    func getLocLatLon(_ addr: String) {
        
        let geocodingUrl = "https://api.geoapify.com/v1/geocode/search?text="
        
        let geocodingAddrEncoded = addr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let geocodingApiKey = Bundle.main.infoDictionary?["Geocoding_API_KEY"] as! String
        
        let geocodingFullUrl = URL(string: geocodingUrl + geocodingAddrEncoded + "&apiKey=" + geocodingApiKey)!
        
        //print(geocodingFullUrl)
        
        var geocodingRequest = URLRequest(url: geocodingFullUrl)
        
        geocodingRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ask the URLSession class for the shared singleton session object for performing the request
        // This method returns a URLSessionDataTask instance and accepts two arguments, a URL object and a completion handler.
        let geocodingReqTask = URLSession.shared.dataTask(with: geocodingRequest, completionHandler: {(data, response, error) in
            if data != nil {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let featuresArr = responseDict["features"] as? [Any]
                        //print(featuresArr!)
                        let firstFeature = featuresArr![0] as? [String: Any]
                        let propertiesDict = firstFeature!["properties"] as? [String: Any]
                        //print(propertiesDict!)
                        //print("Lat: " + String(propertiesDict!["lat"] as! Double))
                        self.reqLat = propertiesDict!["lat"] as? Double ?? 0.00
                        //print("Lon: " + String(propertiesDict!["lon"] as! Double))
                        self.reqLon = propertiesDict!["lon"] as? Double ?? 0.00
                        self.reqCity = propertiesDict!["city"] as? String ?? ""
                        self.reqState = propertiesDict!["state"] as? String ?? ""
                        if(propertiesDict!.keys.contains("housenumber")) {
                            self.reqAddr = propertiesDict!["address_line1"] as? String ?? ""
                        }
                    } else {
                        print("Error converting responseJSON to dictionary")
                    }
                } else {
                    print("Failed to deserialize JSON")
                }
                DispatchQueue.main.async {
                    // we can only directly select the currently selected view's labels
                    // because if the user hasn't switched to another view before then the label's don't exist
                    // to the code.
                    
                    // for the other views we will push the values to their view controllers through the prepare function
                    if(self.selectedIndex == 0) {
                        (self.viewControllers?[0] as! AirQualityContentViewController).airQualCityLabel.text = self.reqCity
                        (self.viewControllers?[0] as! AirQualityContentViewController).airQualStateLabel.text = self.reqState
                        if(self.reqAddr != "None") {
                            (self.viewControllers?[0] as! AirQualityContentViewController).airQualAddrLabel.text = self.reqAddr
                        }
                        (self.viewControllers?[0] as! AirQualityContentViewController).airQualLatLabel.text = "Lat: " + String(self.reqLat)
                        (self.viewControllers?[0] as! AirQualityContentViewController).airQualLonLabel.text = "Lon: " + String(self.reqLon)
                    } else if(self.selectedIndex == 1) {
                        (self.viewControllers?[1] as! PlantContentViewController).plantCityLabel.text = self.reqCity
                        (self.viewControllers?[1] as! PlantContentViewController).plantStateLabel.text = self.reqState
                        if(self.reqAddr != "None") {
                            (self.viewControllers?[1] as! PlantContentViewController).plantAddrLabel.text = self.reqAddr
                        }
                        (self.viewControllers?[1] as! PlantContentViewController).plantLatLabel.text = "Lat: " + String(self.reqLat)
                        (self.viewControllers?[1] as! PlantContentViewController).plantLonLabel.text = "Lon: " + String(self.reqLon)
                    } else if(self.selectedIndex == 2) {
                        (self.viewControllers?[2] as! WeatherContentViewController).weatherCityLabel.text = self.reqCity
                        (self.viewControllers?[2] as! WeatherContentViewController).weatherStateLabel.text = self.reqState
                        if(self.reqAddr != "None") {
                            (self.viewControllers?[2] as! WeatherContentViewController).weatherAddrLabel.text = self.reqAddr
                        }
                        (self.viewControllers?[2] as! WeatherContentViewController).weatherLatLabel.text = "Lat: " + String(self.reqLat)
                        (self.viewControllers?[2] as! WeatherContentViewController).weatherLonLabel.text = "Lon: " + String(self.reqLon)
                    } else if(self.selectedIndex == 3) {
                        (self.viewControllers?[3] as! FireWaterContentViewController).fireWaterCityLabel.text = self.reqCity
                        (self.viewControllers?[3] as! FireWaterContentViewController).fireWaterStateLabel.text = self.reqState
                        if(self.reqAddr != "None") {
                            (self.viewControllers?[3] as! FireWaterContentViewController).fireWaterAddrLabel.text = self.reqAddr
                        }
                        (self.viewControllers?[3] as! FireWaterContentViewController).fireWaterLatLabel.text = "Lat: " + String(self.reqLat)
                        (self.viewControllers?[3] as! FireWaterContentViewController).fireWaterLonLabel.text = "Lon: " + String(self.reqLon)
                    } else if(self.selectedIndex == 4) {
                        (self.viewControllers?[4] as! SoilContentViewController).soilCityLabel.text = self.reqCity
                        (self.viewControllers?[4] as! SoilContentViewController).soilStateLabel.text = self.reqState
                        if(self.reqAddr != "None") {
                            (self.viewControllers?[4] as! SoilContentViewController).soilAddrLabel.text = self.reqAddr
                        }
                        (self.viewControllers?[4] as! SoilContentViewController).soilLatLabel.text = "Lat: " + String(self.reqLat)
                        (self.viewControllers?[4] as! SoilContentViewController).soilLonLabel.text = "Lon: " + String(self.reqLon)
                    }
                    
                    self.prevSearch = addr
                    
                    self.getLocAttrs()
                }
            } else {
                print("Did not get any data from geocoding request")
            }
        })
    
        // call resume() on the task to execute it
        geocodingReqTask.resume()
    }
    
    func getLocAttrs() {
        
        // air quality url https://api.ambeedata.com/latest/by-lat-lng?lat=X&lng=X
        // green house gas url  https://api.ambeedata.com/ghg/latest/by-lat-lng?lat=X&lng=X
        // weather url https://api.ambeedata.com/weather/latest/by-lat-lng?lat=X&lng=X
        // pollen url https://api.ambeedata.com/latest/pollen/by-lat-lng?lat=X&lng=X
        // fire url https://api.ambeedata.com/latest/fire?lat=X&lng=X
        // soil url  https://api.ambeedata.com/soil/latest/by-lat-lng?lat=X&lng=X
        // NDVI url https://api.ambeedata.com/ndvi/latest/by-lat-lng?lat=X&lng=X
        // watervapor url  https://api.ambeedata.com/waterVapor/history/by-lat-lng?lat=X&lng=X&from=2020-07-13 12:16:44&to=2020-07-18 08:16:44
        
        let ambeeApiKey = Bundle.main.infoDictionary?["Ambee_API_KEY"] as! String
        
        // build the request for each url and then execute them all at the end
        
        // AIR QUALITY API
        let airQualityUrl = "https://api.ambeedata.com/latest/by-lat-lng?lat=" + String(reqLat)
            + "&lng=" + String(reqLon)
        
        let airQualityUrlObj = URL(string: airQualityUrl)!
        
        var airQualityRequest = URLRequest(url: airQualityUrlObj)
        
        airQualityRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        airQualityRequest.setValue(ambeeApiKey, forHTTPHeaderField: "x-api-key")
        
        let airQualityReqTask = URLSession.shared.dataTask(with: airQualityRequest, completionHandler: {(data, response, error) in
            
            if data != nil {
                print("Got some data")
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let stationsArr = responseDict["stations"] as? [[String:Any]]
                        let stationsDict = stationsArr?[0]
                        self.locAttrs["airQualAQI"] = stationsDict!["AQI"]! as? Int
                        self.locAttrs["airQualNO2"] = stationsDict!["NO2"]! as? Double
                        self.locAttrs["airQualOZONE"] = stationsDict!["OZONE"] as? Double
                        self.locAttrs["airQualPM10"] = stationsDict!["PM10"] as? Double
                        self.locAttrs["airQualPM25"] = stationsDict!["PM25"] as? Double
                        self.locAttrs["airQualSO2"] = stationsDict!["SO2"] as? Double
                        self.locAttrs["airQualAQIPollutant"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["pollutant"] as? String
                        self.locAttrs["airQualAQIConcentration"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["concentration"] as? Double
                        self.locAttrs["airQualAQICategory"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["category"] as? String
                    } else {
                        print("Error converting responseJSON to dictionary")
                    }
                } else {
                    print("Failed to deserialize JSON")
                }
            }else {
                print("No data returned")
            }
        })
        
        /*let ghgUrl = "https://api.ambeedata.com/ghg/latest/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
        let ghgUrlEncoded = ghgUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let weatherUrl = "https://api.ambeedata.com/weather/latest/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
        let weatherUrlEncoded = weatherUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let pollenUrl = "https://api.ambeedata.com/latest/pollen/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
        let pollenUrlEncoded = pollenUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let fireUrl = "https://api.ambeedata.com/latest/fire?lat=" + String(lat) + "&lng=" + String(lon)
        
        let fireUrlEncoded = fireUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let soilUrl = "https://api.ambeedata.com/soil/latest/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
        let soilUrlEncoded = soilUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let waterVaporUrl = "https://api.ambeedata.com/ndvi/latest/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
        let waterVaporUrlEncoded = waterVaporUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)*/
        
        
        airQualityReqTask.resume()
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
