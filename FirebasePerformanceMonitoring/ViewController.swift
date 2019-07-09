//
//  ViewController.swift
//  FirebasePerformanceMonitoring
//
//  Created by Eduardo Ribeiro da Silva on 09/07/19.
//  Copyright © 2019 Eduardo Ribeiro da Silva. All rights reserved.
//

import UIKit
import FirebasePerformance
import Alamofire

class ViewController: UIViewController {
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "simpleScreenTransition" {
            activityIndicator.startAnimating()
            Utils.waitFor(max: 4)
            activityIndicator.stopAnimating()
            return true
        }
        
        return false
    }
    
    @IBAction func buttonCustomTrace(_ sender: UIButton) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.global(qos: .background).async {
            let trace = Performance.startTrace(name: "custom_trace")
            Utils.waitFor(max: 4)
            trace?.stop()
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                Utils.alert(forView: self, message: "Trace generated")
            }
        }
    }
    
    @IBAction func httpRequestPressed(_ sender: UIButton) {
        AF.request("https://caixaseguradora-mobile-api.herokuapp.com/category_properties").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
}

