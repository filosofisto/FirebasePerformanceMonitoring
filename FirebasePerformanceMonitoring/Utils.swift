//
//  Utils.swift
//  FirebasePerformanceMonitoring
//
//  Created by Eduardo Ribeiro da Silva on 09/07/19.
//  Copyright © 2019 Eduardo Ribeiro da Silva. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func waitFor(max: UInt32) {
        sleep(arc4random_uniform(max)+1)
    }
    
    static func alert(forView: UIViewController, message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        forView.present(alert, animated: true)
    }
}
