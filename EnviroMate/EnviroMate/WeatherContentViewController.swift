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
        (self.tabBarController as! TabBarController).getLocLatLon(weatherLocTextField.text!)
    }
    
    
    @IBAction func onTapGuestureRecognized(_ sender: Any) {
        weatherLocTextField.resignFirstResponder()
        // update the ui
        (self.tabBarController as! TabBarController).getLocLatLon(weatherLocTextField.text!)
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
    
    /*func getLocAttrs(_ lat: Double, _ lon: Double) {
        
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
        
        let ghgUrl = "https://api.ambeedata.com/ghg/latest/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
        let weatherUrl = "https://api.ambeedata.com/weather/latest/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
        let pollenUrl = "https://api.ambeedata.com/latest/pollen/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
        let fireUrl = "https://api.ambeedata.com/latest/fire?lat=" + String(lat) + "&lng=" + String(lon)
        
        let soilUrl = "https://api.ambeedata.com/soil/latest/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
        let waterVaporUrl = "https://api.ambeedata.com/ndvi/latest/by-lat-lng?lat=" + String(lat) + "&lng=" + String(lon)
        
    }*/

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
