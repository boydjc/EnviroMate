//
//  WeatherContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/10/22.
//

import UIKit

class WeatherContentViewController: UIViewController {

    @IBOutlet weak var weatherLocTextField: UITextField!
    
    
    @IBAction func weatherLocTextFieldEditingFinished(_ sender: UITextField) {
        sender.resignFirstResponder()
        // update the ui
    }
    
    @IBOutlet weak var weatherLatLabel: UILabel!
    @IBOutlet weak var weatherLonLabel: UILabel!
    
    
    @IBAction func onTapGuestureRecognized(_ sender: Any) {
        weatherLocTextField.resignFirstResponder()
        // update the ui
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func getLocLatLon() {
        
        let geocodingUrl = "https://api.geoapify.com/v1/geocode/search?text="
        
        let addr = "New York City, New York"
        
        let geocodingAddrEncoded = addr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let geocodingApiKey = Bundle.main.infoDictionary?["Geocoding_API_KEY"] as! String
        
        let geocodingFullUrl = URL(string: geocodingUrl + geocodingAddrEncoded + "&apiKey=" + geocodingApiKey)!
        
        print(geocodingFullUrl)
        
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
                        //print(propertiesDict!["address_line1"]!)
                        //print(propertiesDict!["address_line2"]!)
                        print("Lat: " + String(propertiesDict!["lat"] as! Double))
                        let lat = propertiesDict!["lat"] as? Double
                        print("Lon: " + String(propertiesDict!["lon"] as! Double))
                        let lon = propertiesDict!["lon"] as? Double
                    } else {
                        print("Error converting responseJSON to dictionary")
                    }
                } else {
                    print("Failed to deserialize JSON")
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
