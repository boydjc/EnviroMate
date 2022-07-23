//
//  SoilContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/11/22.
//

import UIKit

class SoilContentViewController: UIViewController {

    @IBOutlet weak var soilScrollView: UIScrollView!
    
    @IBOutlet weak var soilContentView: UIView!
    @IBOutlet weak var soilLocTextField: UITextField!
    
    @IBOutlet weak var soilCityLabel: UILabel!
    @IBOutlet weak var soilStateLabel: UILabel!
    @IBOutlet weak var soilAddrLabel: UILabel!
    @IBOutlet weak var soilLatLabel: UILabel!
    @IBOutlet weak var soilLonLabel: UILabel!
    
    
    @IBOutlet weak var soilMoistureLabel: UILabel!
    @IBOutlet weak var soilTemperatureLabel: UILabel!
    
    
    @IBAction func soilLocTextFieldDoneEditing(_ sender: UITextField) {
        if(sender.text != "") {
            // update the ui
            (self.tabBarController as! TabBarController).getLocLatLon(soilLocTextField.text!)
        }
        sender.resignFirstResponder()
    }
    
    
    @IBAction func tapGuestureRecognized(_ sender: Any) {
        if(soilLocTextField.text != "") {
            // update the ui
            (self.tabBarController as! TabBarController).getLocLatLon(soilLocTextField.text!)
        }
        soilLocTextField.resignFirstResponder()
    }
    
    func clearDataLabels() {
        soilMoistureLabel.text = "Loading..."
        soilTemperatureLabel.text = "Loading..."
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create a gradient layer for the content view.
        let gradientLayer = CAGradientLayer()
        // Set the size of the layer to be equal to size of the display.
        gradientLayer.frame = soilContentView.bounds
        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
        // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.locations = [0, 0.8]
        let todayDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: todayDate)
        if(hour > 17) {
            gradientLayer.colors = [#colorLiteral(red: 0.4183843954, green: 0.3103790425, blue: 0.1158298796, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
            soilScrollView.backgroundColor = #colorLiteral(red: 0.4183843954, green: 0.3103790425, blue: 0.1158298796, alpha:    1)
        } else {
            gradientLayer.colors = [#colorLiteral(red: 0.5838552713, green: 0.4331338406, blue: 0.1616405547, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
            soilScrollView.backgroundColor = #colorLiteral(red: 0.5838552713, green: 0.4331338406, blue: 0.1616405547, alpha: 1)
        }
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        // Apply the gradient to the backgroundGradientView and scroll view.
        soilContentView.layer.insertSublayer(gradientLayer, at: 0)
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
