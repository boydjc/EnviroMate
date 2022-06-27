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
        
        /* Concept code for access API with stored key*/
        let geocodingUrl = "https://api.geoapify.com/v1/geocode/search?text="
        
        let geocodingUrlParams = "jackson, mississippi"
        
        let geocodingUrlParamsEncoded = geocodingUrlParams.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let geocodingApiKey = Bundle.main.infoDictionary?["Geocoding_API_KEY"] as! String
        
        let geocodingFullReqUrl = geocodingUrl + geocodingUrlParamsEncoded + "&apiKey=" + geocodingApiKey
        
        print(geocodingUrl)
        print(geocodingUrlParams)
        print(geocodingUrlParamsEncoded)
        
        print(geocodingFullReqUrl)
        
    }
}

