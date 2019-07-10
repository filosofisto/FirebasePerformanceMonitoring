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
            return true
        }
        
        return false
    }
    
    @IBAction func buttonCustomTrace(_ sender: UIButton) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.global(qos: .background).async {
            let trace = Performance.startTrace(name: "custom_trace")
            trace?.incrementMetric("custom_trace", by: 1)
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
        var proxyConfiguration = [NSObject: AnyObject]()
        proxyConfiguration[kCFNetworkProxiesHTTPProxy] = "webproxy.rootbrasil.intranet" as AnyObject?
        proxyConfiguration[kCFNetworkProxiesHTTPPort] = "80" as AnyObject?
        proxyConfiguration[kCFNetworkProxiesHTTPEnable] = 1 as AnyObject?
        proxyConfiguration[kCFProxyUsernameKey] = "ter81646" as AnyObject?
        proxyConfiguration[kCFProxyPasswordKey] = "********" as AnyObject?
        
        let cfg = Alamofire.SessionManager.default.session.configuration
        cfg.connectionProxyDictionary = proxyConfiguration
        
        let request = Alamofire.request("https://caixaseguradora-mobile-api.herokuapp.com/category_properties")
        request.validate()
        request.response { request in
            if let error = request.error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

