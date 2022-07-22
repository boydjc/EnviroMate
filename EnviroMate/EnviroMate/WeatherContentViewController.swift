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

    @IBOutlet weak var weatherSummaryLabel: UILabel!
    @IBOutlet weak var weatherTemperatureLabel: UILabel!
    @IBOutlet weak var weatherFeelsLikeLabel: UILabel!
    @IBOutlet weak var weatherPrecipitationLabel: UILabel!
    @IBOutlet weak var weatherPrecipIntensityLabel: UILabel!
    @IBOutlet weak var weatherDewPointLabel: UILabel!
    @IBOutlet weak var weatherHumidityLabel: UILabel!
    @IBOutlet weak var weatherAirPressureLabel: UILabel!
    @IBOutlet weak var weatherWindSpeedLabel: UILabel!
    @IBOutlet weak var weatherWindGustLabel: UILabel!
    @IBOutlet weak var weatherWindBearingLabel: UILabel!
    @IBOutlet weak var weatherCloudCoverLabel: UILabel!
    @IBOutlet weak var weatherVisibilityLabel: UILabel!
    
    @IBAction func weatherLocTextFieldEditingFinished(_ sender: UITextField) {
        if(sender.text != "") {
            (self.tabBarController as! TabBarController).getLocLatLon(weatherLocTextField.text!)
        }
        sender.resignFirstResponder()
    }
    
    
    @IBAction func onTapGuestureRecognized(_ sender: Any) {
        if(weatherLocTextField.text != "") {
            (self.tabBarController as! TabBarController).getLocLatLon(weatherLocTextField.text!)
        }
        weatherLocTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create a gradient layer for the content view.
        let gradientLayer = CAGradientLayer()
        // Set the size of the layer to be equal to size of the display.
        gradientLayer.frame = weatherContentView.bounds
        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
        // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.locations = [0, 0.8]
        gradientLayer.colors = [#colorLiteral(red: 0.5303663611, green: 0.8072693944, blue: 0.9225050211, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        // Apply the gradient to the backgroundGradientView and scroll view.
        weatherContentView.layer.insertSublayer(gradientLayer, at: 0)
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
