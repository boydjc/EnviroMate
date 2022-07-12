//
//  FireWaterContentViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 7/11/22.
//

import UIKit

class FireWaterContentViewController: UIViewController {

    @IBOutlet weak var fireWaterLocTextField: UITextField!
    
    @IBAction func tapGuestureRecognized(_ sender: Any) {
        fireWaterLocTextField.resignFirstResponder()
    }
    
    @IBAction func fireWaterLocTextFieldDoneEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
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
