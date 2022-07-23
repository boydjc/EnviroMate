//
//  FireWaterContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/11/22.
//

import UIKit

class FireWaterContentViewController: UIViewController {

    @IBOutlet weak var fireContentView: UIView!
    
    @IBOutlet weak var fireScrollView: UIScrollView!
    
    @IBOutlet weak var fireWaterLocTextField: UITextField!
    @IBOutlet weak var fireWaterCityLabel: UILabel!
    @IBOutlet weak var fireWaterStateLabel: UILabel!
    @IBOutlet weak var fireWaterAddrLabel: UILabel!
    @IBOutlet weak var fireWaterLatLabel: UILabel!
    @IBOutlet weak var fireWaterLonLabel: UILabel!
    
    
    @IBOutlet weak var fireWaterWaterVaporLabel: UILabel!
    
    @IBOutlet weak var fireWaterFireDetectedTitleLabel: UILabel!
    @IBOutlet weak var fireWaterFireDetectedLabel: UILabel!
    @IBOutlet weak var fireWaterFireRadPowTitleLabel: UILabel!
    @IBOutlet weak var fireWaterFireRadPowLabel: UILabel!
    @IBOutlet weak var fireWaterFireLatLabel: UILabel!
    @IBOutlet weak var fireWaterFireLonLabel: UILabel!
    
    
    @IBAction func tapGuestureRecognized(_ sender: Any) {
        if(fireWaterLocTextField.text != "") {
            // update the ui
            (self.tabBarController as! TabBarController).getLocLatLon(fireWaterLocTextField.text!)
        }
        fireWaterLocTextField.resignFirstResponder()
    }
    
    @IBAction func fireWaterLocTextFieldDoneEditing(_ sender: UITextField) {
        if(sender.text != "") {
            // update the ui
            (self.tabBarController as! TabBarController).getLocLatLon(fireWaterLocTextField.text!)
        }
        sender.resignFirstResponder()
    }
    
    func clearDataLabels() {
        fireWaterWaterVaporLabel.text = "Loading..."
        fireWaterFireDetectedLabel.text = "Loading..."
        fireWaterFireRadPowLabel.text = "Loading..."
        fireWaterFireLatLabel.text = "Loading..."
        fireWaterFireLonLabel.text = "Loading..."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create a gradient layer for the content view.
        let gradientLayer = CAGradientLayer()
        // Set the size of the layer to be equal to size of the display.
        gradientLayer.frame = fireContentView.bounds
        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
        // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.locations = [0, 0.8]

        let todayDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: todayDate)
        if(hour > 17) {
            gradientLayer.colors = [#colorLiteral(red: 0.5372851365, green: 0.374276632, blue: 0.1427466914, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
            fireScrollView.backgroundColor = #colorLiteral(red: 0.5382220149, green: 0.3734494448, blue: 0.1455885768, alpha: 1)
        } else {
            gradientLayer.colors = [#colorLiteral(red: 0.7185935974, green: 0.5005773902, blue: 0.1909169853, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
            fireScrollView.backgroundColor = #colorLiteral(red: 0.7185935974, green: 0.5005773902, blue: 0.1909169853, alpha: 1)
        }
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        // Apply the gradient to the backgroundGradientView and scroll view.
        fireContentView.layer.insertSublayer(gradientLayer, at: 0)
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
