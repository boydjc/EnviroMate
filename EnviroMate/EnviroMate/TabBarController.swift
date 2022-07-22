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
                        self.locAttrs["airQualCo2"] = stationsDict!["CO"]! as? Double
                        self.locAttrs["airQualAqi"] = stationsDict!["AQI"]! as? Int
                        self.locAttrs["airQualNo2"] = stationsDict!["NO2"]! as? Double
                        self.locAttrs["airQualOzone"] = stationsDict!["OZONE"] as? Double
                        self.locAttrs["airQualPm10"] = stationsDict!["PM10"] as? Double
                        self.locAttrs["airQualPm25"] = stationsDict!["PM25"] as? Double
                        self.locAttrs["airQualSo2"] = stationsDict!["SO2"] as? Double
                        self.locAttrs["airQualAqiPollutant"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["pollutant"] as? String
                        self.locAttrs["airQualAqiConcentration"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["concentration"] as? Double
                        self.locAttrs["airQualAqiCategory"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["category"] as? String
                        
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 0) {
                                let viewController = self.viewControllers?[self.selectedIndex] as! AirQualityContentViewController
                                viewController.airQualCo2ConcenLabel.text = String(self.locAttrs["airQualCo2"] as! Double) + " (ppm)"
                                viewController.airQualNo2ConcenLabel.text = String(self.locAttrs["airQualNo2"] as! Double) + " (ppb)"
                                viewController.airQualOzoneConcenLabel.text = String(self.locAttrs["airQualOzone"] as! Double) + " (ppb)"
                                viewController.airQualPartMatUnderTenLabel.text = String(self.locAttrs["airQualPm10"] as! Double) + " (ug/m3)"
                                viewController.airQualPartMatUnderTwoFiveLabel.text = String(self.locAttrs["airQualPm25"] as! Double) + " (ug/m3)"
                                viewController.airQualSulpherConcenLabel.text = String(self.locAttrs["airQualSo2"] as! Double) + " (ppb)"
                                viewController.airQualIndexLabel.text = String(self.locAttrs["airQualAqi"] as! Int)
                                viewController.airQualPollutantLabel.text = (self.locAttrs["airQualAqiPollutant"] as! String)
                                // later this concentration unit value needs to be changed to reflect the appropriate
                                // unit for the type of pollutant. The various units of measurements are ppm, ppb, (ug/m3)
                                if((self.locAttrs["airQualAqiPollutant"] as! String) == "PM2.5" || (self.locAttrs["airQualAqiPollutant"] as! String) == "PM10"){
                                    viewController.airQualPollConcenLabel.text = String(self.locAttrs["airQualAqiConcentration"] as! Double) + " (ug/m3)"
                                }else if((self.locAttrs["airQualAqiPollutant"] as! String) == "SO2" || (self.locAttrs["airQualAqiPollutant"] as! String) == "NO2") {
                                    viewController.airQualPollConcenLabel.text = String(self.locAttrs["airQualAqiConcentration"] as! Double) + " (ppb)"
                                }else if((self.locAttrs["airQualAqiPollutant"] as! String) == "CO") {
                                    viewController.airQualPollConcenLabel.text = String(self.locAttrs["airQualAqiConcentration"] as! Double) + " (ppm)"
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
                        
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 0) {
                                let viewController = self.viewControllers?[self.selectedIndex] as! AirQualityContentViewController
                                viewController.airQualOzoneValueLabel.text = self.locAttrs["ghgOzoneValue"] as! String + " molecules/cm2"
                                viewController.airQualCo2LevelLabel.text = self.locAttrs["ghgCo2Value"] as! String + " ppmv"
                                viewController.airQualCh4LevelLabel.text = self.locAttrs["ghgCh4Value"] as! String + " molecules/cm2"
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
                        print(weatherDataDict!)
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
                                let viewController = self.viewControllers?[self.selectedIndex] as! WeatherContentViewController
                                viewController.weatherSummaryLabel.text = (self.locAttrs["weatherSummary"] as! String)
                                viewController.weatherTemperatureLabel.text = " " + String(self.locAttrs["weatherTemperature"] as! Double) + "˚"
                                viewController.weatherFeelsLikeLabel.text = "Feels Like: " + String(self.locAttrs["weatherApparentTemp"] as! Double) + "˚"
                                if !((self.locAttrs["precipIntensity"] as? Double ?? 0.00) == 0.00) {
                                    viewController.weatherPrecipitationLabel.text = "Precipitation: " + (self.locAttrs["weatherPrecipType"] as! String)
                                    viewController.weatherPrecipIntensityLabel.text = "Intensity: " + String(self.locAttrs["weatherPrecipIntensity"] as! Double)
                                }else {
                                    viewController.weatherPrecipitationLabel.text = ""
                                    viewController.weatherPrecipIntensityLabel.text = ""
                                }
                                
                                viewController.weatherDewPointLabel.text = "Dew Point: " + String(self.locAttrs["weatherDewPoint"] as! Double)
                                viewController.weatherHumidityLabel.text = "Humidity: " + String(self.locAttrs["weatherHumidity"] as! Double)
                                viewController.weatherAirPressureLabel.text = "Air Pressure: " + String(self.locAttrs["weatherPressure"] as! Double)
                                viewController.weatherWindSpeedLabel.text = "Wind Speed: " + String(self.locAttrs["weatherWindSpeed"] as! Double)
                                viewController.weatherWindGustLabel.text = "Wind Gust: " + String(self.locAttrs["weatherWindGust"] as! Double)
                                viewController.weatherWindBearingLabel.text = "Wind Bearing: " + String(self.locAttrs["weatherWindBearing"] as! Int)
                                viewController.weatherCloudCoverLabel.text = "Cloud Cover: " + String(self.locAttrs["weatherCloudCover"] as! Double)
                                viewController.weatherVisibilityLabel.text = "Visibility: " + String(self.locAttrs["weatherVisibility"] as! Double)
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
                        //print(pollenDataDict!)
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
                        self.locAttrs["pollenSpeciesOther"] = pollenSpeciesDict!["Others"]
                        
                        // pollen count data
                        let pollenCountDict = pollenDataDict!["Count"] as? [String:Int]
                        self.locAttrs["pollenCountWeed"] = pollenCountDict!["weed_pollen"]
                        self.locAttrs["pollenCountGrass"] = pollenCountDict!["grass_pollen"]
                        self.locAttrs["pollenCountTree"] = pollenCountDict!["tree_pollen"]
                        
                        // pollen risk data
                        let pollenRiskDict = pollenDataDict!["Risk"] as? [String:String]
                        self.locAttrs["pollenRiskGrass"] = pollenRiskDict!["grass_pollen"]
                        self.locAttrs["pollenRiskTree"] = pollenRiskDict!["tree_pollen"]
                        self.locAttrs["pollenRiskWeed"] = pollenRiskDict!["weed_pollen"]
                        
                        print(self.locAttrs)
                        
                        DispatchQueue.main.async {
                            if(self.selectedIndex == 1) {
                                let viewController = self.viewControllers?[self.selectedIndex] as! PlantContentViewController
                                // updating tree labels
                                viewController.plantTreeRiskLabel.text = "Risk: " + (self.locAttrs["pollenRiskTree"] as! String)
                                viewController.plantTreePollenCountLabel.text = "Pollen Count: " + String(self.locAttrs["pollenCountTree"] as? Int ?? 0)
                                if(self.locAttrs["pollenCountTreeAlder"] as? Int ?? 0 != 0) {
                                    viewController.plantTreeAlderLabel.text = String(self.locAttrs["pollenCountTreeAlder"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreeBirch"] as? Int ?? 0 != 0) {
                                    viewController.plantTreeBirchLabel.text = String(self.locAttrs["pollenCountTreeBirch"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreeCypress"] as? Int ?? 0 != 0) {
                                    viewController.plantTreeCypressLabel.text = String(self.locAttrs["pollenCountTreeCypress"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreeElm"] as? Int ?? 0 != 0) {
                                    viewController.plantTreeElmLabel.text = String(self.locAttrs["pollenCountTreeElm"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreeHazel"] as? Int ?? 0 != 0) {
                                    viewController.plantTreeHazelLabel.text = String(self.locAttrs["pollenCountTreeHazel"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreeOak"] as? Int ?? 0 != 0) {
                                    viewController.plantTreeOakLabel.text = String(self.locAttrs["pollenCountTreeOak"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreePine"] as? Int ?? 0 != 0) {
                                    viewController.plantTreePineLabel.text = String(self.locAttrs["pollenCountTreePine"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreePlane"] as? Int ?? 0 != 0) {
                                    viewController.plantTreePlaneLabel.text = String(self.locAttrs["pollenCountTreePlane"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreePoplar"] as? Int ?? 0 != 0) {
                                    viewController.plantTreePoplarLabel.text = String(self.locAttrs["pollenCountTreePoplar"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreeCottenwood"] as? Int ?? 0 != 0) {
                                    viewController.plantTreeCottenwoodLabel.text = String(self.locAttrs["pollenCountTreeCottenwood"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreeJuniper"] as? Int ?? 0 != 0) {
                                    viewController.plantTreeJuniperLabel.text = String(self.locAttrs["pollenCountTreeJuniper"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenCountTreeCedar"] as? Int ?? 0 != 0) {
                                    viewController.plantTreeCedarLabel.text = String(self.locAttrs["pollenCountTreeCedar"] as? Int ?? 0)
                                }
                                
                                // updating weed labels
                                viewController.plantWeedRiskLabel.text = "Risk: " + (self.locAttrs["pollenRiskWeed"] as! String)
                                viewController.plantWeedPollenCountLabel.text = "Pollen Count: " + String(self.locAttrs["pollenCountWeed"] as? Int ?? 0)
                                if(self.locAttrs["pollenSpeciesWeedNettle"] as? Int ?? 0 != 0) {
                                    viewController.plantWeedNettleLabel.text = String(self.locAttrs["pollenSpeciesWeedNettle"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenSpeciesWeedMugwort"] as? Int ?? 0 != 0) {
                                    viewController.plantWeedMugwortLabel.text = String(self.locAttrs["pollenSpeciesWeedMugwort"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenSpeciesWeedRagweed"] as? Int ?? 0 != 0) {
                                    viewController.plantWeedRagweedLabel.text = String(self.locAttrs["pollenSpeciesWeedRagweed"] as? Int ?? 0)
                                }
                                
                                if(self.locAttrs["pollenSpeciesWeedChenopod"] as? Int ?? 0 != 0) {
                                    viewController.plantWeedChenopodLabel.text = String(self.locAttrs["pollenSpeciesWeedChenopod"] as? Int ?? 0)
                                }
                                
                                // updating grass labels
                                viewController.plantGrassRiskLabel.text = (self.locAttrs["pollenRiskGrass"] as! String)
                                viewController.plantGrassPollenCountLabel.text = "Pollen Count: " + String(self.locAttrs["pollenCountGrass"] as! Int)
                                
                                if((self.locAttrs["pollenSpeciesGrassGrass"] as? Int ?? 0) == (self.locAttrs["pollenSpeciesGrassPoaceae"] as? Int ?? 0)) {
                                    viewController.plantGrassGrassLabel.text = "0"
                                } else {
                                    viewController.plantGrassGrassLabel.text = String(self.locAttrs["pollenSpeciesGrassGrass"] as? Int ?? 0)
                                }
                                viewController.plantGrassPoaceaeLabel.text = String(self.locAttrs["pollenSpeciesGrassPoaceae"] as? Int ?? 0)
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
                            print(self.locAttrs)
                            DispatchQueue.main.async {
                                if(self.selectedIndex == 3) {
                                    let viewController = self.viewControllers?[self.selectedIndex] as! FireWaterContentViewController
                                    if((self.locAttrs["fireDetectionTime"] as! String) != "None") {
                                        viewController.fireWaterFireDetectedLabel.text = String((self.locAttrs["fireDetectionTime"] as! String).prefix(19))
                                    }
                                    
                                    viewController.fireWaterFireRadPowTitleLabel.text = "Radiation Power: "
                                    viewController.fireWaterFireRadPowLabel.text = String(self.locAttrs["fireRadPow"] as! Double) + " MW"
                                    viewController.fireWaterFireLatLabel.text = "Lat: " + String(self.locAttrs["fireLat"] as! Double)
                                    viewController.fireWaterFireLonLabel.text = "Lon: " + String(self.locAttrs["fireLon"] as! Double)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                let viewController = self.viewControllers?[self.selectedIndex] as! FireWaterContentViewController
                                viewController.fireWaterFireDetectedTitleLabel.text = ""
                                viewController.fireWaterFireDetectedLabel.text = "No fires detected in your area."
                                viewController.fireWaterFireRadPowLabel.text = ""
                                viewController.fireWaterFireRadPowTitleLabel.text = ""
                                viewController.fireWaterFireLatLabel.text = ""
                                viewController.fireWaterFireLonLabel.text = ""
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
                        self.locAttrs["soilMoisture"] = soilDataDict!["soil_moisture"]
                        self.locAttrs["soilTemperature"] = soilDataDict!["soil_temperature"]
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
                        self.locAttrs["ndviSummary"] = ndviDataDict!["summary"]
                        self.locAttrs["ndviEvi"] = ndviDataDict!["evi"]
                        self.locAttrs["ndvi"] = ndviDataDict!["ndvi"]
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
                        self.locAttrs["waterVapor"] = waterVaporDataDict!["water_vapor"]
                        print(self.locAttrs)
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
    
        
        
        //airQualityReqTask.resume()
        //ghgReqTask.resume()
        //weatherReqTask.resume()
        //pollenReqTask.resume()
        fireReqTask.resume()
        //soilReqTask.resume()
        //ndviReqTask.resume()
        //waterVaporReqTask.resume()
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
