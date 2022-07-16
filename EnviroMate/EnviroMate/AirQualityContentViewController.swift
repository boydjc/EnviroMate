//
//  AirQualityContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/11/22.
//

import UIKit

class AirQualityContentViewController: UIViewController {
    
    @IBOutlet weak var airContentView: UIView!
    
    @IBOutlet weak var airQualLocTextField: UITextField!
    
    @IBOutlet weak var airQualCityLabel: UILabel!
    @IBOutlet weak var airQualStateLabel: UILabel!
    @IBOutlet weak var airQualAddrLabel: UILabel!
    @IBOutlet weak var airQualLatLabel: UILabel!
    @IBOutlet weak var airQualLonLabel: UILabel!
    
    @IBAction func airQualLocTextFieldDoneEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
        // update the ui
        (self.tabBarController as! TabBarController).getLocLatLon(airQualLocTextField.text!)
    }
    
    @IBAction func tapGuestureRecognized(_ sender: Any) {
        airQualLocTextField.resignFirstResponder()
        // update the ui
        (self.tabBarController as! TabBarController).getLocLatLon(airQualLocTextField.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create a gradient layer for the content view.
        let gradientLayer = CAGradientLayer()
        // Set the size of the layer to be equal to size of the display.
        gradientLayer.frame = airContentView.bounds
        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
        // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.locations = [0, 0.3]
        gradientLayer.colors = [#colorLiteral(red: 0.01109799836, green: 0.9990333915, blue: 0.9484464526, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        // Apply the gradient to the backgroundGradientView and scroll view.
        airContentView.layer.insertSublayer(gradientLayer, at: 0)
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
