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
                if let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let responseDict = responseJSON as? [String: Any] {
                        let stationsArr = responseDict["stations"] as? [[String:Any]]
                        let stationsDict = stationsArr?[0]
                        self.locAttrs["airQualAqi"] = stationsDict!["AQI"]! as? Int
                        self.locAttrs["airQualNo2"] = stationsDict!["NO2"]! as? Double
                        self.locAttrs["airQualOzone"] = stationsDict!["OZONE"] as? Double
                        self.locAttrs["airQualPm10"] = stationsDict!["PM10"] as? Double
                        self.locAttrs["airQualPm25"] = stationsDict!["PM25"] as? Double
                        self.locAttrs["airQualSo2"] = stationsDict!["SO2"] as? Double
                        self.locAttrs["airQualAqiPollutant"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["pollutant"] as? String
                        self.locAttrs["airQualAqiConcentration"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["concentration"] as? Double
                        self.locAttrs["airQualAqiCategory"] = (stationsDict!["aqiInfo"]! as? [String:Any])!["category"] as? String
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
                        self.locAttrs["ghgOzoneUnits"] = (ghgDataDict!["ozone"]! as? [String:String])!["units"]!
                        self.locAttrs["ghgCo2Value"] = (ghgDataDict!["co2"]! as? [String:String])!["value"]!
                        self.locAttrs["ghgCo2Units"] = (ghgDataDict!["co2"]! as? [String:String])!["units"]!
                        self.locAttrs["ghgCh4Value"] = (ghgDataDict!["ch4"]! as? [String:String])!["value"]!
                        self.locAttrs["ghgCh4Units"] = (ghgDataDict!["ch4"]! as? [String:String])!["units"]!
                        // for some reason casting the values of water_vapor to Int, String, Double, or whatever doesn't seem to work
                        // even though the API documentation shows them as String and what is being actually returned seems to be Int
                        self.locAttrs["ghgWaterVaporValue"] = (ghgDataDict!["water_vapor"]! as? [String:Any])!["value"]!
                        self.locAttrs["ghgWaterVaporUnits"] = (ghgDataDict!["water_vapor"]! as? [String:Any])!["units"]!
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
                        self.locAttrs["weatherPrecipIntensity"] = weatherDataDict!["precipIntensity"]
                        self.locAttrs["weatherPrecipType"] = weatherDataDict!["precipType"] ?? "None"
                        self.locAttrs["weatherTemperature"] = weatherDataDict!["temperature"]
                        self.locAttrs["weatherApprentTemp"] = weatherDataDict!["apparentTemperature"]
                        self.locAttrs["weatherSummary"] = weatherDataDict!["summary"]
                        self.locAttrs["weatherIcon"] = weatherDataDict!["icon"]
                        self.locAttrs["weatherDewPoint"] = weatherDataDict!["dewPoint"]
                        self.locAttrs["weatherHumidity"] = weatherDataDict!["humidity"]
                        self.locAttrs["weatherPressure"] = weatherDataDict!["pressure"]
                        self.locAttrs["weatherWindSpeed"] = weatherDataDict!["windSpeed"]
                        self.locAttrs["weatherWindGust"] = weatherDataDict!["windGust"]
                        self.locAttrs["weatherWindBearing"] = weatherDataDict!["windBearing"]
                        self.locAttrs["weatherCloudCover"] = weatherDataDict!["cloudCover"]
                        self.locAttrs["weatherVisibility"] = weatherDataDict!["visibility"]
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
                        let pollenSpeciesTreeDict = pollenSpeciesDict!["Tree"] as? [String:Int]
                        self.locAttrs["pollenSpeciesTreeMullbery"] = pollenSpeciesTreeDict!["Mulberry"]
                        self.locAttrs["pollenSpeciesTreePine"] = pollenSpeciesTreeDict!["Pine"]
                        self.locAttrs["pollenSpeciesTreeElm"] = pollenSpeciesTreeDict!["Elm"]
                        self.locAttrs["pollenSpeciesTreeBirch"] = pollenSpeciesTreeDict!["Birch"]
                            // the Cypress, juniper and cedar species are all in one value from the api
                        self.locAttrs["pollenSpeciesTreeCypJunCed"] = pollenSpeciesTreeDict!["Cypress / Juniper / Cedar"]
                        self.locAttrs["pollenSpeciesTreeAsh"] = pollenSpeciesTreeDict!["Ash"]
                        self.locAttrs["pollenSpeciesTreeOak"] = pollenSpeciesTreeDict!["Oak"]
                            // the Poplar and cottenwood species are also in one value from the api
                        self.locAttrs["pollenSpeciesTreePopCot"] = pollenSpeciesTreeDict!["Poplar / Cottenwood"]
                        self.locAttrs["pollenSpeciesTreeMaple"] = pollenSpeciesTreeDict!["Maple"]
                        self.locAttrs["pollenSpeciesTreeAlder"] = pollenSpeciesTreeDict!["Alder"]
                        self.locAttrs["pollenSpeciesTreeHazel"] = pollenSpeciesTreeDict!["Hazel"]
                        self.locAttrs["pollenSpeciesTreePlane"] = pollenSpeciesTreeDict!["Plane"]
                            /* for paris the cypress was it's own category, will probably need to find a better way
                             to handle this */
                        self.locAttrs["Cypress"] = pollenSpeciesTreeDict!["Cypress"]
                        
                            // weed species
                        let pollenSpeciesWeedDict = pollenSpeciesDict!["Weed"] as? [String:Int]
                        self.locAttrs["pollenSpeciesWeedChenopod"] = pollenSpeciesWeedDict!["Chenopod"]
                        self.locAttrs["pollenSpeciesWeedRagWeed"] = pollenSpeciesWeedDict!["Ragweed"]
                        self.locAttrs["pollenSpeciesWeedMugwort"] = pollenSpeciesWeedDict!["Mugwort"]
                        self.locAttrs["pollenSpeciesWeedNettle"] = pollenSpeciesWeedDict!["Nettle"]
                        //print(pollenSpeciesWeedDict!)
                        
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
                        let fireDataArr = (responseDict["data"] as? [Any])
                        if(fireDataArr != nil) {
                            for item in fireDataArr! {
                                // there is a chance that there will be multiple fires in the area
                                // this will have to be taken care of later
                                // perhaps by using a small table view to show the nearby fires
                                // we are only interesting in the detection_time and frp
                                print(item)
                            }
                        } else {
                            print("No fire data")
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
         
        /*
         
        let nvdiUrl = "https://api.ambeedata.com/ndvi/latest/by-lat-lng?lat=" + String(lat) + &lng=" + String(lon)
        
        let waterVaporUrl = "https://api.ambeedata.com/ndvi/latest/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
         */
        
        
        //airQualityReqTask.resume()
        //ghgReqTask.resume()
        //weatherReqTask.resume()
        //pollenReqTask.resume()
        //fireReqTask.resume()
        soilReqTask.resume()
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
