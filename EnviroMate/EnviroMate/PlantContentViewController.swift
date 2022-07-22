//
//  PlantContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/11/22.
//

import UIKit

class PlantContentViewController: UIViewController {

    @IBOutlet weak var plantContentView: UIView!
    @IBOutlet weak var plantLocTextField: UITextField!

    @IBOutlet weak var plantCityLabel: UILabel!
    @IBOutlet weak var plantStateLabel: UILabel!
    @IBOutlet weak var plantAddrLabel: UILabel!
    @IBOutlet weak var plantLatLabel: UILabel!
    @IBOutlet weak var plantLonLabel: UILabel!
 
    // tree labels
    @IBOutlet weak var plantTreeRiskLabel: UILabel!
    @IBOutlet weak var plantTreePollenCountLabel: UILabel!
    
    
    
    @IBOutlet weak var plantTreeAlderTitle: UILabel!
    @IBOutlet weak var plantTreeAlderLabel: UILabel!
    
    
    @IBOutlet weak var plantTreeBirchLabel: UILabel!
    @IBOutlet weak var plantTreeCypressLabel: UILabel!
    @IBOutlet weak var plantTreeElmLabel: UILabel!
    @IBOutlet weak var plantTreeHazelLabel: UILabel!
    @IBOutlet weak var plantTreeOakLabel: UILabel!
    @IBOutlet weak var plantTreePineLabel: UILabel!
    @IBOutlet weak var plantTreePlaneLabel: UILabel!
    @IBOutlet weak var plantTreePoplarLabel: UILabel!
    @IBOutlet weak var plantTreeCottenwoodLabel: UILabel!
    @IBOutlet weak var plantTreeJuniperLabel: UILabel!
    @IBOutlet weak var plantTreeCedarLabel: UILabel!
    
    // weed labels
    
    @IBOutlet weak var plantWeedRiskLabel: UILabel!
    @IBOutlet weak var plantWeedPollenCountLabel: UILabel!
    @IBOutlet weak var plantWeedChenopodLabel: UILabel!
    @IBOutlet weak var plantWeedMugwortLabel: UILabel!
    @IBOutlet weak var plantWeedNettleLabel: UILabel!
    @IBOutlet weak var plantWeedRagweedLabel: UILabel!
    
    // grass labels
    
    @IBOutlet weak var plantGrassRiskLabel: UILabel!
    @IBOutlet weak var plantGrassPollenCountLabel: UILabel!
    @IBOutlet weak var plantGrassGrassLabel: UILabel!
    
    
    @IBOutlet weak var plantGrassPoaceaeTitle: UILabel!
    @IBOutlet weak var plantGrassPoaceaeLabel: UILabel!
    
    
    
    
    @IBAction func plantLocTextFieldDoneEditing(_ sender: UITextField) {
        if(sender.text != "") {
            // update the ui
            (self.tabBarController as! TabBarController).getLocLatLon(plantLocTextField.text!)
        }
        sender.resignFirstResponder()
    }
    
    
    @IBAction func tapGuestureRecognized(_ sender: Any) {
        if(plantLocTextField.text != "") {
            // update the ui
            (self.tabBarController as! TabBarController).getLocLatLon(plantLocTextField.text!)
        }
        plantLocTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create a gradient layer for the content view.
        let gradientLayer = CAGradientLayer()
        // Set the size of the layer to be equal to size of the display.
        gradientLayer.frame = plantContentView.bounds
        // Set an array of Core Graphics colors (.cgColor) to create the gradient
        
        gradientLayer.locations = [0, 0.8]
        // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.colors = [#colorLiteral(red: 0.4567747116, green: 0.7525791526, blue: 0.3089949489, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        // Apply the gradient to the backgroundGradientView and scroll view.
        plantContentView.layer.insertSublayer(gradientLayer, at: 0)
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
