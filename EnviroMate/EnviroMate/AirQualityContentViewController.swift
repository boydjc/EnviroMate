//
//  AirQualityContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/11/22.
//

import UIKit

class AirQualityContentViewController: UIViewController {
    
    @IBOutlet weak var airScrollView: UIScrollView!
    
    @IBOutlet weak var airContentView: UIView!
    
    @IBOutlet weak var airQualLocTextField: UITextField!
    
    @IBOutlet weak var airQualCityLabel: UILabel!
    @IBOutlet weak var airQualStateLabel: UILabel!
    @IBOutlet weak var airQualAddrLabel: UILabel!
    @IBOutlet weak var airQualLatLabel: UILabel!
    @IBOutlet weak var airQualLonLabel: UILabel!
    
    
    
    @IBOutlet weak var airQualCo2ConcenLabel: UILabel!
    @IBOutlet weak var airQualNo2ConcenLabel: UILabel!
    @IBOutlet weak var airQualOzoneConcenLabel: UILabel!
    @IBOutlet weak var airQualOzoneValueLabel: UILabel!
    @IBOutlet weak var airQualCo2LevelLabel: UILabel!
    @IBOutlet weak var airQualCh4LevelLabel: UILabel!
    @IBOutlet weak var airQualPartMatUnderTenLabel: UILabel!
    @IBOutlet weak var airQualPartMatUnderTwoFiveLabel: UILabel!
    @IBOutlet weak var airQualSulpherConcenLabel: UILabel!
    @IBOutlet weak var airQualIndexLabel: UILabel!
    @IBOutlet weak var airQualPollutantLabel: UILabel!
    @IBOutlet weak var airQualPollConcenLabel: UILabel!
    
    @IBAction func airQualLocTextFieldDoneEditing(_ sender: UITextField) {
        if(sender.text != "") {
            // update the ui
            (self.tabBarController as! TabBarController).getLocLatLon(airQualLocTextField.text!)
        }
        sender.resignFirstResponder()
    }
    
    @IBAction func tapGuestureRecognized(_ sender: Any) {
        if(airQualLocTextField.text != "") {
            // update the ui
            (self.tabBarController as! TabBarController).getLocLatLon(airQualLocTextField.text!)
        }
        airQualLocTextField.resignFirstResponder()
    }
    
    func clearDataLabels() {
        airQualCo2ConcenLabel.text = "Loading..."
        airQualNo2ConcenLabel.text = "Loading..."
        airQualOzoneConcenLabel.text = "Loading..."
        airQualOzoneValueLabel.text = "Loading..."
        airQualCo2LevelLabel.text = "Loading..."
        airQualCh4LevelLabel.text = "Loading..."
        airQualPartMatUnderTenLabel.text = "Loading..."
        airQualPartMatUnderTwoFiveLabel.text = "Loading..."
        airQualSulpherConcenLabel.text = "Loading..."
        airQualIndexLabel.text = "Loading..."
        airQualPollutantLabel.text = "Loading..."
        airQualPollConcenLabel.text = "Loading..."
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
        gradientLayer.locations = [0, 0.8]
        let todayDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: todayDate)
        if(hour > 17) {
            gradientLayer.colors = [#colorLiteral(red: 0.007741939118, green: 0.696923485, blue: 0.6616341483, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
            airScrollView.backgroundColor = #colorLiteral(red: 0.007741939118, green: 0.696923485, blue: 0.6616341483, alpha: 1)
        } else {
            gradientLayer.colors = [#colorLiteral(red: 0.01109799836, green: 0.9990333915, blue: 0.9484464526, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
            airScrollView.backgroundColor = #colorLiteral(red: 0.01109799836, green: 0.9990333915, blue: 0.9484464526, alpha: 1)
        }
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
