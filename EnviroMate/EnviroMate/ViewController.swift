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
        
        let geocodingUrlParams = "woodbridge, virginia"
        
        let geocodingUrlParamsEncoded = geocodingUrlParams.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let geocodingApiKey = Bundle.main.infoDictionary?["Geocoding_API_KEY"] as! String
        
        let geocodingFullUrl = URL(string: geocodingUrl + geocodingUrlParamsEncoded + "&apiKey=" + geocodingApiKey)!
        
        // https://cocoacasts.com/networking-fundamentals-how-to-make-an-http-request-in-swift
        
        var geocodingRequest = URLRequest(url: geocodingFullUrl)
        
        // ask the URLSession class for the shared singleton session object for performing the request
        // This method returns a URLSessionDataTask instance and accepts two arguments, a URL object and a completion handler.
        let geocodingReqTask = URLSession.shared.dataTask(with: geocodingFullUrl) { data, response, error in
            
            if let responseData = data {
                print(responseData)
            } else {
                print("Did not get any data")
            }
        }
        
        // call resume() on the task to execute it
        
        geocodingReqTask.resume()
        
        
    
        
    }
}

