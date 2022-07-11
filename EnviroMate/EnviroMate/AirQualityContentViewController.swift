//
//  AirQualityContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/11/22.
//

import UIKit

class AirQualityContentViewController: UIViewController {
    
    
    @IBOutlet weak var airQualLocTextField: UITextField!
    
    @IBAction func airQualLocTextFieldDoneEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
        // update the ui
    }
    
    @IBAction func tapGuestureRecognized(_ sender: Any) {
        airQualLocTextField.resignFirstResponder()
        // update the ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
