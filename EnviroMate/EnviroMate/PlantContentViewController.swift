//
//  PlantContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/11/22.
//

import UIKit

class PlantContentViewController: UIViewController {

    
    @IBOutlet weak var plantScrollView: UIScrollView!
    
    @IBOutlet weak var plantContentView: UIView!
    @IBOutlet weak var plantLocTextField: UITextField!

    @IBOutlet weak var plantCityLabel: UILabel!
    @IBOutlet weak var plantStateLabel: UILabel!
    @IBOutlet weak var plantAddrLabel: UILabel!
    @IBOutlet weak var plantLatLabel: UILabel!
    @IBOutlet weak var plantLonLabel: UILabel!
    
    @IBOutlet weak var plantEviLabel: UILabel!
    @IBOutlet weak var plantNdviLabel: UILabel!
    @IBOutlet weak var plantSummaryLabel: UILabel!
    
    // tree labels
    @IBOutlet weak var plantTreeRiskLabel: UILabel!
    @IBOutlet weak var plantTreePollenCountLabel: UILabel!
    
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
    
    func clearDateLabels() {
        plantEviLabel.text = "Loading..."
        plantNdviLabel.text = "Loading..."
        plantSummaryLabel.text = "Loading..."
        plantTreeRiskLabel.text = "Loading..."
        plantTreePollenCountLabel.text = "Loading..."
        plantTreeAlderLabel.text = "Loading..."
        plantTreeBirchLabel.text = "Loading..."
        plantTreeCypressLabel.text = "Loading..."
        plantTreeElmLabel.text = "Loading..."
        plantTreeHazelLabel.text = "Loading..."
        plantTreeOakLabel.text = "Loading..."
        plantTreePineLabel.text = "Loading..."
        plantTreePlaneLabel.text = "Loading..."
        plantTreePoplarLabel.text = "Loading..."
        plantTreeCottenwoodLabel.text = "Loading..."
        plantTreeJuniperLabel.text = "Loading..."
        plantTreeCedarLabel.text = "Loading..."
        plantWeedRiskLabel.text = "Loading..."
        plantWeedPollenCountLabel.text = "Loading..."
        plantWeedChenopodLabel.text = "Loading..."
        plantWeedMugwortLabel.text = "Loading..."
        plantWeedNettleLabel.text = "Loading..."
        plantWeedRagweedLabel.text = "Loading..."
        plantGrassRiskLabel.text = "Loading..."
        plantGrassPollenCountLabel.text = "Loading..."
        plantGrassGrassLabel.text = "Loading..."
        plantGrassPoaceaeLabel.text = "Loading..."
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
        let todayDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: todayDate)
        if(hour >= 17) {
            gradientLayer.colors = [#colorLiteral(red: 0.3331985459, green: 0.5489758363, blue: 0.2253992286, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
            plantScrollView.backgroundColor = #colorLiteral(red: 0.3331985459, green: 0.5489758363, blue: 0.2253992286, alpha: 1)
        } else {
            gradientLayer.colors = [#colorLiteral(red: 0.4567747116, green: 0.7525791526, blue: 0.3089949489, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
            plantScrollView.backgroundColor = #colorLiteral(red: 0.4567747116, green: 0.7525791526, blue: 0.3089949489, alpha: 1)
        }
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
