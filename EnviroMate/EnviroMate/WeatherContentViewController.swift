//
//  WeatherContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/10/22.
//

import UIKit

class WeatherContentViewController: UIViewController{

    @IBOutlet weak var weatherLocTextField: UITextField!
    
    @IBOutlet weak var weatherContentView: UIView!
    @IBOutlet weak var weatherScrollView: UIScrollView!
    
    @IBOutlet weak var weatherCityLabel: UILabel!
    @IBOutlet weak var weatherStateLabel: UILabel!
    @IBOutlet weak var weatherAddrLabel: UILabel!
    @IBOutlet weak var weatherLatLabel: UILabel!
    @IBOutlet weak var weatherLonLabel: UILabel!
    
    @IBAction func weatherLocTextFieldEditingFinished(_ sender: UITextField) {
        sender.resignFirstResponder()
        // update the ui
        getLocLatLon(weatherLocTextField.text!)
    }
    
    
    @IBAction func onTapGuestureRecognized(_ sender: Any) {
        weatherLocTextField.resignFirstResponder()
        // update the ui
        getLocLatLon(weatherLocTextField.text!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create a gradient layer for the content view.
        let gradientLayer = CAGradientLayer()
        // Set the size of the layer to be equal to size of the display.
        gradientLayer.frame = view.bounds
        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
        // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.locations = [0, 0.3]
        gradientLayer.colors = [#colorLiteral(red: 0.5303663611, green: 0.8072693944, blue: 0.9225050211, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        // Apply the gradient to the backgroundGradientView and scroll view.
        weatherContentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
    func getLocAttrs(_ lat: Double, _ lon: Double) {
        
        // air quality url https://api.ambeedata.com/latest/by-lat-lng?lat=X&lng=X
        // green house gas url  https://api.ambeedata.com/ghg/latest/by-lat-lng?lat=X&lng=X
        // weather url https://api.ambeedata.com/weather/latest/by-lat-lng?lat=X&lng=X
        // pollen url https://api.ambeedata.com/latest/pollen/by-lat-lng?lat=X&lng=X
        // fire url https://api.ambeedata.com/latest/fire?lat=X&lng=X
        // soil url  https://api.ambeedata.com/soil/latest/by-lat-lng?lat=X&lng=X
        // NDVI url https://api.ambeedata.com/ndvi/latest/by-lat-lng?lat=X&lng=X
        // watervapor url  https://api.ambeedata.com/waterVapor/history/by-lat-lng?lat=X&lng=X&from=2020-07-13 12:16:44&to=2020-07-18 08:16:44
        
        //let ambeeApiKey = Bundle.main.infoDictionary?["Ambee_API_KEY"] as! String
        let ambeeApiTESTKey = "keykeykey123"
        
        let airQualityUrl = "https://api.ambeedata.com/latest/by-lat-lng?lat=" + String(lat)
            + "&lng=" + String(lon)
        
        
        
        
    }
    
    func getLocLatLon(_ addr: String) {
        
        let geocodingUrl = "https://api.geoapify.com/v1/geocode/search?text="
        
        //let addr = "New York City, New York"
        
        let geocodingAddrEncoded = addr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let geocodingApiKey = Bundle.main.infoDictionary?["Geocoding_API_KEY"] as! String
        
        let geocodingFullUrl = URL(string: geocodingUrl + geocodingAddrEncoded + "&apiKey=" + geocodingApiKey)!
        
        //print(geocodingFullUrl)
        
        var geocodingRequest = URLRequest(url: geocodingFullUrl)
        
        geocodingRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var lat = 0.00
        var lon = 0.00
        var city = ""
        var state = ""
        var addr = ""
        
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
                        print(propertiesDict!)
                        //print("Lat: " + String(propertiesDict!["lat"] as! Double))
                        lat = propertiesDict!["lat"] as? Double ?? 0.00
                        //print("Lon: " + String(propertiesDict!["lon"] as! Double))
                        lon = propertiesDict!["lon"] as? Double ?? 0.00
                        city = propertiesDict!["city"] as? String ?? "Error"
                        state = propertiesDict!["state"] as? String ?? "Error"
                        if(propertiesDict!.keys.contains("housenumber")) {
                            addr = propertiesDict!["address_line1"] as? String ?? "Error"
                        }
                    } else {
                        print("Error converting responseJSON to dictionary")
                    }
                } else {
                    print("Failed to deserialize JSON")
                }
                DispatchQueue.main.async {
                    self.weatherCityLabel.text = city
                    self.weatherStateLabel.text = state
                    self.weatherLatLabel.text = "Lat: " + String(lat)
                    self.weatherLonLabel.text = "Lon: " + String(lon)
                    self.weatherAddrLabel.text = addr
                }
            } else {
                print("Did not get any data from geocoding request")
            }
        })
    
        // call resume() on the task to execute it
        geocodingReqTask.resume()
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
