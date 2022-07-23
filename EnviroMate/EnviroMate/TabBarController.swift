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
    var locAttrs: [String:Any?] = [:]
    

    
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
            populateAirData()
            populateGhgData()
        } else if(viewController == tabBarController.viewControllers![1]) {
            populatePollenData()
            populateNvdiData()
        } else if(viewController == tabBarController.viewControllers![2]) {
            populateWeatherData()
        } else if(viewController == tabBarController.viewControllers![3]) {
            if(self.locAttrs.keys.contains("fireDetectionTime")) {
                populateFireData(isFire: true)
            } else {
                populateFireData(isFire: false)
            }
            populateWaterVaporData()
        } else if(viewController == tabBarController.viewControllers![4]) {
            populateSoilData()
        }
    }
    
    func getLocLatLon(_ addr: String) {
        
        let geocodingUrl = "https://api.geoapify.com/v1/geocode/search?text="
        
        let geocodingAddrEncoded = addr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let geocodingApiKey = Bundle.main.infoDictionary?["Geocoding_API_KEY"] as! String
        
        let geocodingFullUrl = URL(string: geocodingUrl + geocodingAddrEncoded + "&apiKey=" + geocodingApiKey)!
        
        var geocodingRequest = URLRequest(url: geocodingFullUrl)
        
        geocodingRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ask the URLSession class for the shared singleton session object for performing the request
        // This method returns a URLSessionDataTask instance and accepts two arguments, a URL object and a completion handler.
        let geocodingReqTask = URLSession.shared.dataTask(with: geocodingRequest, completionHandler: {(data, response, error) in
            if data != nil {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let featuresArr = responseDict["features"] as? [Any]
                        let firstFeature = featuresArr![0] as? [String: Any]
                        let propertiesDict = firstFeature!["properties"] as? [String: Any]
                        self.reqLat = propertiesDict!["lat"] as? Double ?? 0.00
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
                    
                    // for the other views we will push the values to their view controllers later
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
        // watervapor url  https://api.ambeedata.com/waterVapor/latest/by-lat-lng?lat=X&lng=X
        
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
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let stationsArr = responseDict["stations"] as? [[String:Any]]
                        let stationsDict = stationsArr?[0]
                        self.locAttrs["airQualCo2"] = stationsDict!["CO"]! as? Double ?? 0.00
                        self.locAttrs["airQualAqi"] = stationsDict!["AQI"]! as? Int ?? 0
                        self.locAttrs["airQualNo2"] = stationsDict!["NO2"]! as? Double ?? 0.00
                        self.locAttrs["airQualOzone"] = stationsDict!["OZONE"] as? Double ?? 0.00
                        self.locAttrs["airQualPm10"] = stationsDict!["PM10"] as? Double ?? 0.00
                        self.locAttrs["airQualPm25"] = stationsDict!["PM25"] as? Double ?? 0.00
                        self.locAttrs["airQualSo2"] = stationsDict!["SO2"] as? Double ?? 0.00
                        self.locAttrs["airQualAqiPollutant"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["pollutant"] as? String ?? "0.00"
                        self.locAttrs["airQualAqiConcentration"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["concentration"] as? Double ?? 0.00
                        self.locAttrs["airQualAqiCategory"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["category"] as? String ?? "0.00"
                        
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 0) {
                                self.populateAirData()
                            }
                        }
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
        
        // Greenhouse gas (ghg) API
        
        let ghgUrl = "https://api.ambeedata.com/ghg/latest/by-lat-lng?lat=" + String(reqLat) + "&lng=" + String(reqLon)

        let ghgUrlObj = URL(string: ghgUrl)!
         
        var ghgRequest = URLRequest(url: ghgUrlObj)
         
        ghgRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        ghgRequest.setValue(ambeeApiKey, forHTTPHeaderField: "x-api-key")
         
        let ghgReqTask = URLSession.shared.dataTask(with: ghgRequest, completionHandler: {(data, response, error) in
             
            if data != nil {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let ghgDataArr = responseDict["data"] as? [Any]
                        if(!(ghgDataArr!.isEmpty)) {
                            let ghgDataDict = ghgDataArr![0] as? [String:Any]
                            self.locAttrs["ghgOzoneValue"] = (ghgDataDict!["ozone"]! as? [String:String])!["value"]!
                            self.locAttrs["ghgCo2Value"] = (ghgDataDict!["co2"]! as? [String:String])!["value"]!
                            self.locAttrs["ghgCo2Units"] = (ghgDataDict!["co2"]! as? [String:String])!["units"]!
                            self.locAttrs["ghgCh4Value"] = (ghgDataDict!["ch4"]! as? [String:String])!["value"]!
                            self.locAttrs["ghgCh4Units"] = (ghgDataDict!["ch4"]! as? [String:String])!["units"]!
                            // for some reason casting the values of water_vapor to Int, String, Double, or whatever doesn't seem to work
                            // even though the API documentation shows them as String and what is being actually returned seems to be Int
                            self.locAttrs["ghgWaterVaporValue"] = (ghgDataDict!["water_vapor"]! as? [String:Any])!["value"]!
                            self.locAttrs["ghgWaterVaporUnits"] = (ghgDataDict!["water_vapor"]! as? [String:Any])!["units"]!
                        } else {
                            self.locAttrs["ghgOzoneValue"] = "Unavailable"
                            self.locAttrs["ghgCo2Value"] = "Unavailable"
                            self.locAttrs["ghgCo2Units"] = "Unavailable"
                            self.locAttrs["ghgCh4Value"] = "Unavailable"
                            self.locAttrs["ghgCh4Units"] = "Unavailable"
                            self.locAttrs["ghgWaterVaporValue"] = "Unavailable"
                            self.locAttrs["ghgWaterVaporUnits"] = "Unavailable"
                        }
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 0) {
                                self.populateGhgData()
                            }
                        }
                    }
                }
            }
        })
        
        // weather API
        let weatherUrl = "https://api.ambeedata.com/weather/latest/by-lat-lng?lat=" + String(reqLat) + "&lng=" + String(reqLon)

        let weatherUrlObj = URL(string: weatherUrl)!
          
        var weatherRequest = URLRequest(url: weatherUrlObj)
          
        weatherRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        weatherRequest.setValue(ambeeApiKey, forHTTPHeaderField: "x-api-key")
          
        let weatherReqTask = URLSession.shared.dataTask(with: weatherRequest, completionHandler: {(data, response, error) in
              
            if data != nil {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let weatherDataDict = responseDict["data"] as? [String:Any]
                        self.locAttrs["weatherPrecipIntensity"] = weatherDataDict!["precipIntensity"] as? Double ?? 0.00
                        self.locAttrs["weatherPrecipType"] = weatherDataDict!["precipType"] ?? "None"
                        self.locAttrs["weatherTemperature"] = weatherDataDict!["temperature"] as? Double ?? 0.00
                        self.locAttrs["weatherApparentTemp"] = weatherDataDict!["apparentTemperature"] as? Double ?? 0.00
                        self.locAttrs["weatherSummary"] = weatherDataDict!["summary"] ?? "None"
                        self.locAttrs["weatherIcon"] = weatherDataDict!["icon"]
                        self.locAttrs["weatherDewPoint"] = weatherDataDict!["dewPoint"] as? Double ?? 0.00
                        self.locAttrs["weatherHumidity"] = weatherDataDict!["humidity"] as? Double ?? 0.00
                        self.locAttrs["weatherPressure"] = weatherDataDict!["pressure"] as? Double ?? 0.00
                        self.locAttrs["weatherWindSpeed"] = weatherDataDict!["windSpeed"] as? Double ?? 0.00
                        self.locAttrs["weatherWindGust"] = weatherDataDict!["windGust"] as? Double ?? 0.00
                        self.locAttrs["weatherWindBearing"] = weatherDataDict!["windBearing"] as? Int ?? 0
                        self.locAttrs["weatherCloudCover"] = weatherDataDict!["cloudCover"] as? Double ?? 0.00
                        self.locAttrs["weatherVisibility"] = weatherDataDict!["visibility"] as? Double ?? 0.00
                        
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 2) {
                                self.populateWeatherData()
                            }
                        }
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

        // pollen API
        let pollenUrl = "https://api.ambeedata.com/latest/pollen/by-lat-lng?lat=" + String(reqLat) + "&lng=" + String(reqLon)
        
        let pollenUrlObj = URL(string: pollenUrl)!
          
        var pollenRequest = URLRequest(url: pollenUrlObj)
          
        pollenRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        pollenRequest.setValue(ambeeApiKey, forHTTPHeaderField: "x-api-key")
          
        let pollenReqTask = URLSession.shared.dataTask(with: pollenRequest, completionHandler: {(data, response, error) in
              
            if data != nil {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let pollenDataArr = responseDict["data"] as? [Any]
                        // the data dictionary has several parts with nested dictionaries
                        // The top level has 3: Species, Pollen Count, and Risk
                        // we are parsing each one of them separtely here
                        let pollenDataDict = pollenDataArr![0] as? [String:Any]
                        // species data
                        let pollenSpeciesDict = pollenDataDict!["Species"] as? [String:Any]
                            // tree species
                        let pollenSpeciesTreeDict = pollenSpeciesDict!["Tree"] as? [String:Any]
                        
                        for (key) in pollenSpeciesTreeDict!.keys {
                            if(key.contains("/")) {
                                let mulKeys = key.components(separatedBy: "/")
                                for (item) in mulKeys {
                                    let strippedKey = item.trimmingCharacters(in: .whitespaces)
                                    self.locAttrs["pollenSpeciesTree" + strippedKey] = pollenSpeciesTreeDict![key] as? Int ?? 0
                                }
                            }else {
                                self.locAttrs["pollenSpeciesTree" + key] = pollenSpeciesTreeDict![key] as? Int ?? 0
                            }
                        }
                        
                        // weed species
                        let pollenSpeciesWeedDict = pollenSpeciesDict!["Weed"] as? [String:Any]
                        for (key) in pollenSpeciesWeedDict!.keys {
                            if(key.contains("/")) {
                                let mulKeys = key.components(separatedBy: "/")
                                for (item) in mulKeys {
                                    let strippedKey = item.trimmingCharacters(in: .whitespaces)
                                    self.locAttrs["pollenSpeciesWeed" + strippedKey] = pollenSpeciesWeedDict![key] as? Int ?? 0
                                }
                            }else {
                                self.locAttrs["pollenSpeciesWeed" + key] = pollenSpeciesWeedDict![key] as? Int ?? 0
                            }
                        }
                        
                        // grass species
                        let pollenSpeciesGrassDict = pollenSpeciesDict!["Grass"] as? [String:Any]
                        for (key) in pollenSpeciesGrassDict!.keys {
                            if(key.contains("/")) {
                                let mulKeys = key.components(separatedBy: "/")
                                for (item) in mulKeys {
                                    let strippedKey = item.trimmingCharacters(in: .whitespaces)
                                    self.locAttrs["pollenSpeciesGrass" + strippedKey] = pollenSpeciesGrassDict![key] as? Int ?? 0
                                }
                            }else {
                                self.locAttrs["pollenSpeciesGrass" + key] = pollenSpeciesGrassDict![key] as? Int ?? 0
                            }
                        }
                        
                        // other species
                        self.locAttrs["pollenSpeciesOther"] = pollenSpeciesDict!["Others"] as? Int ?? 0
                        
                        // pollen count data
                        let pollenCountDict = pollenDataDict!["Count"] as? [String:Int]
                        self.locAttrs["pollenCountWeed"] = pollenCountDict!["weed_pollen"] ?? 0
                        self.locAttrs["pollenCountGrass"] = pollenCountDict!["grass_pollen"] ?? 0
                        self.locAttrs["pollenCountTree"] = pollenCountDict!["tree_pollen"] ?? 0
                        
                        // pollen risk data
                        let pollenRiskDict = pollenDataDict!["Risk"] as? [String:String]
                        self.locAttrs["pollenRiskGrass"] = pollenRiskDict!["grass_pollen"] ?? "None"
                        self.locAttrs["pollenRiskTree"] = pollenRiskDict!["tree_pollen"] ?? "None"
                        self.locAttrs["pollenRiskWeed"] = pollenRiskDict!["weed_pollen"] ?? "None"
                        
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 1) {
                                self.populatePollenData()
                            }
                        }
                        
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

        // fire API
        let fireUrl = "https://api.ambeedata.com/latest/fire?lat=" + String(reqLat) + "&lng=" + String(reqLon)
        
        let fireUrlObj = URL(string: fireUrl)!
          
        var fireRequest = URLRequest(url: fireUrlObj)
          
        fireRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        fireRequest.setValue(ambeeApiKey, forHTTPHeaderField: "x-api-key")
          
        let fireReqTask = URLSession.shared.dataTask(with: fireRequest, completionHandler: {(data, response, error) in
              
            if data != nil {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let fireDataArr = (responseDict["data"] as? [[String:Any]])
                        if(fireDataArr != nil) {
                            let fireData = fireDataArr![0]
                            self.locAttrs["fireDetectionTime"] = fireData["detection_time"] as? String ?? "None"
                            self.locAttrs["fireRadPow"] = fireData["frp"] as? Double ?? 0.00
                            self.locAttrs["fireLat"] = fireData["lat"] as? Double ?? 0.00
                            self.locAttrs["fireLon"] = fireData["lon"] as? Double ?? 0.00
                            DispatchQueue.main.async {
                                if(self.selectedIndex == 3) {
                                    self.populateFireData(isFire: true)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                if(self.selectedIndex == 3) {
                                    self.populateFireData(isFire: false)
                                }
                            }
                        }
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
        
        // soil API
        let soilUrl = "https://api.ambeedata.com/soil/latest/by-lat-lng?lat=" + String(reqLat) + "&lng=" + String(reqLon)
        
        let soilUrlObj = URL(string: soilUrl)!
          
        var soilRequest = URLRequest(url: soilUrlObj)
          
        soilRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        soilRequest.setValue(ambeeApiKey, forHTTPHeaderField: "x-api-key")
          
        let soilReqTask = URLSession.shared.dataTask(with: soilRequest, completionHandler: {(data, response, error) in
              
            if data != nil {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let soilDataArr = (responseDict["data"] as? [Any])
                        let soilDataDict = soilDataArr![0] as? [String:Any]
                        self.locAttrs["soilMoisture"] = soilDataDict!["soil_moisture"] as? Double ?? 0.00
                        self.locAttrs["soilTemperature"] = soilDataDict!["soil_temperature"] as? Double ?? 0.00
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 4) {
                                self.populateSoilData()
                            }
                        }
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
        
        // ndvi API
        let ndviUrl = "https://api.ambeedata.com/ndvi/latest/by-lat-lng?lat=" + String(reqLat) + "&lng=" + String(reqLon)
        
        let ndviUrlObj = URL(string: ndviUrl)!
          
        var ndviRequest = URLRequest(url: ndviUrlObj)
          
        ndviRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        ndviRequest.setValue(ambeeApiKey, forHTTPHeaderField: "x-api-key")
          
        let ndviReqTask = URLSession.shared.dataTask(with: ndviRequest, completionHandler: {(data, response, error) in
              
            if data != nil {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let ndviDataArr = (responseDict["data"] as? [Any])
                        let ndviDataDict = ndviDataArr![0] as? [String:Any]
                        self.locAttrs["ndviSummary"] = ndviDataDict!["summary"] as? String ?? "No Summary Found"
                        self.locAttrs["ndviEvi"] = ndviDataDict!["evi"] as? Double ?? 0.00
                        self.locAttrs["ndvi"] = ndviDataDict!["ndvi"] as? Double ?? 0.00
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 1) {
                                self.populateNvdiData()
                            }
                        }
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
         
        
        let waterVaporUrl = "https://api.ambeedata.com/waterVapor/latest/by-lat-lng?lat=" + String(reqLat) + "&lng=" + String(reqLon)
    
        let waterVaporUrlObj = URL(string: waterVaporUrl)!
          
        var waterVaporRequest = URLRequest(url: waterVaporUrlObj)
          
        waterVaporRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        waterVaporRequest.setValue(ambeeApiKey, forHTTPHeaderField: "x-api-key")
          
        let waterVaporReqTask = URLSession.shared.dataTask(with: waterVaporRequest, completionHandler: {(data, response, error) in
              
            if data != nil {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let waterVaporDataArr = (responseDict["data"] as? [Any])
                        let waterVaporDataDict = waterVaporDataArr![0] as? [String:Any]
                        self.locAttrs["waterVapor"] = waterVaporDataDict!["water_vapor"] as? Double ?? 0.00
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 3) {
                                self.populateWaterVaporData()
                            }
                        }
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
    
        
        
        airQualityReqTask.resume()
        ghgReqTask.resume()
        weatherReqTask.resume()
        pollenReqTask.resume()
        fireReqTask.resume()
        soilReqTask.resume()
        ndviReqTask.resume()
        waterVaporReqTask.resume()
    }

    func populateAirData() {
        let airViewController = self.viewControllers?[self.selectedIndex] as! AirQualityContentViewController
        airViewController.clearDataLabels()
        if(reqCity != "") {
            airViewController.airQualCityLabel.text = reqCity
        }
        
        if(reqState != "") {
            airViewController.airQualStateLabel.text = reqState
        }
        
        if(reqAddr != "None") {
            airViewController.airQualAddrLabel.text = reqAddr
        }
        
        if(reqLat != 0.00) {
            airViewController.airQualLatLabel.text = "Lat: " + String(reqLat)
        }
        
        if(reqLon != 0.00) {
            airViewController.airQualLonLabel.text = "Lon: " + String(reqLon)
        }
        
        if(prevSearch != "") {
            airViewController.airQualLocTextField.text = prevSearch
        }
        
        if(self.locAttrs.keys.contains("airQualCo2")) {
            airViewController.airQualCo2ConcenLabel.text = String(self.locAttrs["airQualCo2"] as! Double) + " (ppm)"
        }else {
            airViewController.airQualCo2ConcenLabel.text = ""
        }
    
        if(self.locAttrs.keys.contains("airQualAqi")) {
            airViewController.airQualIndexLabel.text = String(self.locAttrs["airQualAqi"] as! Int)
        }else {
            airViewController.airQualIndexLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("airQualNo2")) {
            airViewController.airQualNo2ConcenLabel.text = String(self.locAttrs["airQualNo2"] as! Double) + " (ppb)"
        } else {
            airViewController.airQualNo2ConcenLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("airQualOzone")) {
            airViewController.airQualOzoneConcenLabel.text = String(self.locAttrs["airQualOzone"] as! Double) + " (ppb)"
        } else {
            airViewController.airQualOzoneConcenLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("airQualPm10")) {
            airViewController.airQualPartMatUnderTenLabel.text = String(self.locAttrs["airQualPm10"] as! Double) + " (ug/m3)"
        } else {
            airViewController.airQualPartMatUnderTenLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("airQualPm25")) {
            airViewController.airQualPartMatUnderTwoFiveLabel.text = String(self.locAttrs["airQualPm25"] as! Double) + " (ug/m3)"
        } else {
            airViewController.airQualPartMatUnderTwoFiveLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("airQualSo2")) {
            airViewController.airQualSulpherConcenLabel.text = String(self.locAttrs["airQualSo2"] as! Double) + " (ppb)"
        } else {
            airViewController.airQualSulpherConcenLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("airQualAqiPollutant")) {
            airViewController.airQualPollutantLabel.text = (self.locAttrs["airQualAqiPollutant"] as! String)
        } else {
            airViewController.airQualPollutantLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("airQualAqiPollutant")) {
            if((self.locAttrs["airQualAqiPollutant"] as! String) == "PM2.5" || (self.locAttrs["airQualAqiPollutant"] as! String) == "PM10"){
                airViewController.airQualPollConcenLabel.text = String(self.locAttrs["airQualAqiConcentration"] as! Double) + " (ug/m3)"
            }else if((self.locAttrs["airQualAqiPollutant"] as! String) == "SO2" || (self.locAttrs["airQualAqiPollutant"] as! String) == "NO2") {
                airViewController.airQualPollConcenLabel.text = String(self.locAttrs["airQualAqiConcentration"] as! Double) + " (ppb)"
            }else if((self.locAttrs["airQualAqiPollutant"] as! String) == "CO") {
                airViewController.airQualPollConcenLabel.text = String(self.locAttrs["airQualAqiConcentration"] as! Double) + " (ppm)"
            }else if((self.locAttrs["airQualAqiPollutant"] as! String) == "O3") {
                airViewController.airQualPollConcenLabel.text = String(self.locAttrs["airQualAqiConcentration"] as! Double) + " (ppm)"
            }
        } else {
            airViewController.airQualPollConcenLabel.text = ""
        }
    }
    
    func populateGhgData() {
        // greenhouse data is on the air view
        let airViewController = self.viewControllers?[self.selectedIndex] as! AirQualityContentViewController
        if(reqCity != "") {
            airViewController.airQualCityLabel.text = reqCity
        }
        
        if(reqState != "") {
            airViewController.airQualStateLabel.text = reqState
        }
        
        if(reqAddr != "None") {
            airViewController.airQualAddrLabel.text = reqAddr
        }
        
        if(reqLat != 0.00) {
            airViewController.airQualLatLabel.text = "Lat: " + String(reqLat)
        }
        
        if(reqLon != 0.00) {
            airViewController.airQualLonLabel.text = "Lon: " + String(reqLon)
        }
        
        if(prevSearch != "") {
            airViewController.airQualLocTextField.text = prevSearch
        }
        
        if(self.locAttrs.keys.contains("ghgOzoneValue")) {
            airViewController.airQualOzoneValueLabel.text = self.locAttrs["ghgOzoneValue"] as! String + " molecules/cm2"
        } else {
            airViewController.airQualOzoneValueLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("ghgCo2Value")) {
            airViewController.airQualCo2LevelLabel.text = self.locAttrs["ghgCo2Value"] as! String + " ppmv"
        } else {
            airViewController.airQualCo2LevelLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("ghgCh4Value")) {
            airViewController.airQualCh4LevelLabel.text = self.locAttrs["ghgCh4Value"] as! String + " molecules/cm2"
        } else {
            airViewController.airQualCh4LevelLabel.text = ""
        }
    }
    
    func populateWeatherData() {
        let weatherViewController = self.viewControllers?[self.selectedIndex] as! WeatherContentViewController
        weatherViewController.clearDataLabels()
        if(reqCity != "") {
            weatherViewController.weatherCityLabel.text = reqCity
        }
        
        if(reqState != "") {
            weatherViewController.weatherStateLabel.text = reqState
        }
        
        if(reqAddr != "None") {
            weatherViewController.weatherAddrLabel.text = reqAddr
        }
        
        if(reqLat != 0.00) {
            weatherViewController.weatherLatLabel.text = "Lat: " + String(reqLat)
        }
        
        if(reqLon != 0.00) {
            weatherViewController.weatherLonLabel.text = "Lon: " + String(reqLon)
        }
        
        if(prevSearch != "") {
            weatherViewController.weatherLocTextField.text = prevSearch
        }
        
        if(self.locAttrs.keys.contains("weatherSummary")) {
            weatherViewController.weatherSummaryLabel.text = (self.locAttrs["weatherSummary"] as! String)
        } else {
            weatherViewController.weatherSummaryLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherTemperature")) {
            weatherViewController.weatherTemperatureLabel.text = " " + String(self.locAttrs["weatherTemperature"] as! Double) + "˚"
        } else {
            weatherViewController.weatherTemperatureLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherApparentTemp")) {
            weatherViewController.weatherFeelsLikeLabel.text = "Feels Like: " + String(self.locAttrs["weatherApparentTemp"] as! Double) + "˚"
        } else {
            weatherViewController.weatherFeelsLikeLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("precipIntensity")) {
            if !((self.locAttrs["precipIntensity"] as? Double ?? 0.00) == 0.00) {
                weatherViewController.weatherPrecipitationLabel.text = "Precipitation: " + (self.locAttrs["weatherPrecipType"] as! String)
                weatherViewController.weatherPrecipIntensityLabel.text = "Intensity: " + String(self.locAttrs["weatherPrecipIntensity"] as! Double)
            }
        }else {
            weatherViewController.weatherPrecipitationLabel.text = ""
            weatherViewController.weatherPrecipIntensityLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherDewPoint")) {
            weatherViewController.weatherDewPointLabel.text = "Dew Point: " + String(self.locAttrs["weatherDewPoint"] as! Double)
        } else {
            weatherViewController.weatherDewPointLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherHumidity")) {
            weatherViewController.weatherHumidityLabel.text = "Humidity: " + String(self.locAttrs["weatherHumidity"] as! Double)
        } else {
            weatherViewController.weatherHumidityLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherPressure")) {
            weatherViewController.weatherAirPressureLabel.text = "Air Pressure: " + String(self.locAttrs["weatherPressure"] as! Double)
        } else {
            weatherViewController.weatherAirPressureLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherWindSpeed")) {
            weatherViewController.weatherWindSpeedLabel.text = "Wind Speed: " + String(self.locAttrs["weatherWindSpeed"] as! Double)
        } else {
            weatherViewController.weatherWindSpeedLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherWindGust")) {
            weatherViewController.weatherWindGustLabel.text = "Wind Gust: " + String(self.locAttrs["weatherWindGust"] as! Double)
        } else {
            weatherViewController.weatherWindGustLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherWindBearing")) {
            weatherViewController.weatherWindBearingLabel.text = "Wind Bearing: " + String(self.locAttrs["weatherWindBearing"] as! Int)
        } else {
            weatherViewController.weatherWindBearingLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherCloudCover")) {
            weatherViewController.weatherCloudCoverLabel.text = "Cloud Cover: " + String(self.locAttrs["weatherCloudCover"] as! Double)
        } else {
            weatherViewController.weatherCloudCoverLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("weatherVisibility")) {
            weatherViewController.weatherVisibilityLabel.text = "Visibility: " + String(self.locAttrs["weatherVisibility"] as! Double)
        } else {
            weatherViewController.weatherVisibilityLabel.text = ""
        }
    }
    
    func populatePollenData() {
        let plantViewController = self.viewControllers?[self.selectedIndex] as! PlantContentViewController
        plantViewController.clearDateLabels()
        if(reqCity != "") {
            plantViewController.plantCityLabel.text = reqCity
        }
        
        if(reqState != "") {
            plantViewController.plantStateLabel.text = reqState
        }
        
        if(reqAddr != "None") {
            plantViewController.plantAddrLabel.text = reqAddr
        }
        
        if(reqLat != 0.00) {
            plantViewController.plantLatLabel.text = "Lat: " + String(reqLat)
        }
        
        if(reqLon != 0.00) {
            plantViewController.plantLonLabel.text = "Lon: " + String(reqLon)
        }
        
        if(prevSearch != "") {
            plantViewController.plantLocTextField.text = prevSearch
        }
        
        // updating tree labels
        if(self.locAttrs.keys.contains("pollenRiskTree")) {
            plantViewController.plantTreeRiskLabel.text = "Risk: " + (self.locAttrs["pollenRiskTree"] as! String)
        } else {
            plantViewController.plantTreeRiskLabel.text = "Risk: None"
        }
        
        if(self.locAttrs.keys.contains("pollenCountTree")) {
            plantViewController.plantTreePollenCountLabel.text = "Pollen Count: " + String(self.locAttrs["pollenCountTree"] as! Int)
        } else {
            plantViewController.plantTreePollenCountLabel.text = "Pollen Count: None"
        }
            
        if(self.locAttrs.keys.contains("pollenCountTreeAlder")) {
            plantViewController.plantTreeAlderLabel.text = String(self.locAttrs["pollenCountTreeAlder"] as! Int)
        } else {
            plantViewController.plantTreeAlderLabel.text = ""
        }

        
        if(self.locAttrs.keys.contains("pollenCountTreeBirch")) {
            plantViewController.plantTreeBirchLabel.text = String(self.locAttrs["pollenCountTreeBirch"] as! Int)
        } else {
            plantViewController.plantTreeBirchLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreeCypress")) {
            plantViewController.plantTreeCypressLabel.text = String(self.locAttrs["pollenCountTreeCypress"] as! Int)
        } else {
            plantViewController.plantTreeCypressLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreeElm")) {
            plantViewController.plantTreeElmLabel.text = String(self.locAttrs["pollenCountTreeElm"] as! Int)
        } else {
            plantViewController.plantTreeElmLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreeHazel")) {
            plantViewController.plantTreeHazelLabel.text = String(self.locAttrs["pollenCountTreeHazel"] as! Int)
        } else {
            plantViewController.plantTreeHazelLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreeOak")) {
            plantViewController.plantTreeOakLabel.text = String(self.locAttrs["pollenCountTreeOak"] as! Int)
        } else {
            plantViewController.plantTreeOakLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreePine")) {
            plantViewController.plantTreePineLabel.text = String(self.locAttrs["pollenCountTreePine"] as! Int)
        } else {
            plantViewController.plantTreePineLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreePlane")) {
            plantViewController.plantTreePlaneLabel.text = String(self.locAttrs["pollenCountTreePlane"] as! Int)
        } else {
            plantViewController.plantTreePlaneLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreePoplar")) {
            plantViewController.plantTreePoplarLabel.text = String(self.locAttrs["pollenCountTreePoplar"] as! Int)
        } else {
            plantViewController.plantTreePoplarLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreeCottenwood")) {
            plantViewController.plantTreeCottenwoodLabel.text = String(self.locAttrs["pollenCountTreeCottenwood"] as! Int)
        } else {
            plantViewController.plantTreeCottenwoodLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreeJuniper")) {
            plantViewController.plantTreeJuniperLabel.text = String(self.locAttrs["pollenCountTreeJuniper"] as! Int)
        } else {
            plantViewController.plantTreeJuniperLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenCountTreeCedar")) {
            plantViewController.plantTreeCedarLabel.text = String(self.locAttrs["pollenCountTreeCedar"] as! Int)
        } else {
            plantViewController.plantTreeCedarLabel.text = ""
        }
        
        // updating weed labels
        if(self.locAttrs.keys.contains("pollenRiskWeed")) {
            plantViewController.plantWeedRiskLabel.text = "Risk: " + (self.locAttrs["pollenRiskWeed"] as! String)
        } else {
            plantViewController.plantWeedRiskLabel.text = "Risk: None"
        }
        
        if(self.locAttrs.keys.contains("pollenCountWeed")) {
            plantViewController.plantWeedPollenCountLabel.text = "Pollen Count: " + String(self.locAttrs["pollenCountWeed"] as! Int)
        } else {
            plantViewController.plantWeedPollenCountLabel.text = "Pollen Count: None"
        }
        
        if(self.locAttrs.keys.contains("pollenSpeciesWeedNettle")) {
            plantViewController.plantWeedNettleLabel.text = String(self.locAttrs["pollenSpeciesWeedNettle"] as! Int)
        } else {
            plantViewController.plantWeedNettleLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenSpeciesWeedMugwort")) {
            plantViewController.plantWeedMugwortLabel.text = String(self.locAttrs["pollenSpeciesWeedMugwort"] as! Int)
        } else {
            plantViewController.plantWeedMugwortLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenSpeciesWeedRagweed")) {
            plantViewController.plantWeedRagweedLabel.text = String(self.locAttrs["pollenSpeciesWeedRagweed"] as! Int)
        } else {
            plantViewController.plantWeedRagweedLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("pollenSpeciesWeedChenopod")) {
            plantViewController.plantWeedChenopodLabel.text = String(self.locAttrs["pollenSpeciesWeedChenopod"] as! Int)
        } else {
            plantViewController.plantWeedChenopodLabel.text = ""
        }
        
        // updating grass labels
        if(self.locAttrs.keys.contains("pollenRiskGrass")) {
            plantViewController.plantGrassRiskLabel.text = "Risk: " + (self.locAttrs["pollenRiskGrass"] as! String)
        } else {
            plantViewController.plantGrassRiskLabel.text = "Risk: None"
        }
        
        if(self.locAttrs.keys.contains("pollenCountGrass")) {
            plantViewController.plantGrassPollenCountLabel.text = "Pollen Count: " + String(self.locAttrs["pollenCountGrass"] as! Int)
        } else {
            plantViewController.plantGrassPollenCountLabel.text = "Pollen Count: None"
        }
        
        if(self.locAttrs.keys.contains("pollenSpeciesGrassGrass") || self.locAttrs.keys.contains("pollenSpeciesGrassPoaceae")) {
            if((self.locAttrs["pollenSpeciesGrassGrass"] as? Int ?? 0) == (self.locAttrs["pollenSpeciesGrassPoaceae"] as? Int ?? 0)) {
                plantViewController.plantGrassGrassLabel.text = "0"
            } else {
                plantViewController.plantGrassGrassLabel.text = String(self.locAttrs["pollenSpeciesGrassGrass"] as? Int ?? 0)
            }
            plantViewController.plantGrassPoaceaeLabel.text = String(self.locAttrs["pollenSpeciesGrassPoaceae"] as? Int ?? 0)
        } else {
            plantViewController.plantGrassGrassLabel.text = "None"
            plantViewController.plantGrassPoaceaeLabel.text = "None"
        }
    }
    
    func populateFireData(isFire: Bool) {
        let fireViewController = self.viewControllers?[self.selectedIndex] as! FireWaterContentViewController
        fireViewController.clearDataLabels()
        if(reqCity != "") {
            fireViewController.fireWaterCityLabel.text = reqCity
        }
        
        if(reqState != "") {
            fireViewController.fireWaterStateLabel.text = reqState
        }
        
        if(reqAddr != "None") {
            fireViewController.fireWaterAddrLabel.text = reqAddr
        }
        
        if(reqLat != 0.00) {
            fireViewController.fireWaterLatLabel.text = "Lat: " + String(reqLat)
        }
        
        if(reqLon != 0.00) {
            fireViewController.fireWaterLonLabel.text = "Lon: " + String(reqLon)
        }
        
        if(prevSearch != "") {
            fireViewController.fireWaterLocTextField.text = prevSearch
        }
        
        if(isFire) {
            if((self.locAttrs.keys.contains("fireDetectionTime"))) {
                if((self.locAttrs["fireDetectionTime"] as! String) != "None") {
                    fireViewController.fireWaterFireDetectedLabel.text = String((self.locAttrs["fireDetectionTime"] as! String).prefix(19))
                }
            }else {
                fireViewController.fireWaterFireDetectedLabel.text = ""
            }
            
            if(self.locAttrs.keys.contains("fireRadPow")) {
                fireViewController.fireWaterFireRadPowTitleLabel.text = "Radiation Power: "
                fireViewController.fireWaterFireRadPowLabel.text = String(self.locAttrs["fireRadPow"] as! Double) + " MW"
            }else {
                fireViewController.fireWaterFireRadPowTitleLabel.text = ""
                fireViewController.fireWaterFireRadPowLabel.text = ""
            }
            
            if(self.locAttrs.keys.contains("fireLat")) {
                fireViewController.fireWaterFireLatLabel.text = "Lat: " + String(self.locAttrs["fireLat"] as! Double)
            }else {
                fireViewController.fireWaterFireLatLabel.text = ""
            }
            
            if(self.locAttrs.keys.contains("fireLon")) {
                fireViewController.fireWaterFireLonLabel.text = "Lon: " + String(self.locAttrs["fireLon"] as! Double)
            } else {
                fireViewController.fireWaterFireLonLabel.text = ""
            }
        }else {
            fireViewController.fireWaterFireDetectedTitleLabel.text = ""
            fireViewController.fireWaterFireDetectedLabel.text = "No fires detected in your area."
            fireViewController.fireWaterFireRadPowLabel.text = ""
            fireViewController.fireWaterFireRadPowTitleLabel.text = ""
            fireViewController.fireWaterFireLatLabel.text = ""
            fireViewController.fireWaterFireLonLabel.text = ""
        }
    }
    
    func populateSoilData() {
        let soilViewController = self.viewControllers?[self.selectedIndex] as! SoilContentViewController
        soilViewController.clearDataLabels()
        if(reqCity != "") {
            soilViewController.soilCityLabel.text = reqCity
        }
        
        if(reqState != "") {
            soilViewController.soilStateLabel.text = reqState
        }
        
        if(reqAddr != "None") {
            soilViewController.soilAddrLabel.text = reqAddr
        }
        
        if(reqLat != 0.00) {
            soilViewController.soilLatLabel.text = "Lat: " + String(reqLat)
        }
        
        if(reqLon != 0.00) {
            soilViewController.soilLonLabel.text = "Lon: " + String(reqLon)
        }
        
        if(prevSearch != "") {
            soilViewController.soilLocTextField.text = prevSearch
        }
        
        if(self.locAttrs.keys.contains("soilMoisture")) {
            soilViewController.soilMoistureLabel.text = String(round((self.locAttrs["soilMoisture"] as! Double) * 100) / 100) + "%"
        }else {
            soilViewController.soilMoistureLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("soilTemperature")) {
            soilViewController.soilTemperatureLabel.text = String(Int(self.locAttrs["soilTemperature"] as! Double)) + "˚C"
        } else {
            soilViewController.soilTemperatureLabel.text = ""
        }
    }
    
    func populateNvdiData() {
        let plantViewController = self.viewControllers?[self.selectedIndex] as! PlantContentViewController
        if(self.locAttrs.keys.contains("ndvi")) {
            plantViewController.plantNdviLabel.text = String(self.locAttrs["ndvi"] as! Double)
        } else {
            plantViewController.plantNdviLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("ndviEvi")) {
            plantViewController.plantEviLabel.text = String(self.locAttrs["ndviEvi"] as! Double)
        } else {
            plantViewController.plantEviLabel.text = ""
        }
        
        if(self.locAttrs.keys.contains("ndviSummary")) {
            plantViewController.plantSummaryLabel.text = (self.locAttrs["ndviSummary"] as! String)
        } else {
            plantViewController.plantSummaryLabel.text = ""
        }
    }
    
    func populateWaterVaporData() {
        let waterViewController = self.viewControllers?[self.selectedIndex] as! FireWaterContentViewController
        if(self.locAttrs.keys.contains("waterVapor")) {
            waterViewController.fireWaterWaterVaporLabel.text = String(Int(self.locAttrs["waterVapor"] as! Double)) + "cm"
        } else {
            waterViewController.fireWaterWaterVaporLabel.text = ""
        }
    }
}
