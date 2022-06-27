//
//  ViewController.swift
//  EnviroMate
//
//  Created by Joshua Boyd on 6/26/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(Bundle.main.infoDictionary?["Geocoding_API_KEY"] ?? "No Key")
        
    }
}

