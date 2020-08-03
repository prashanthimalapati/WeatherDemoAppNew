//
//  Utils.swift
//  WeatherDemoApp
//
//  Created by prashanthi M on 03/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//

import Foundation
import UIKit

class AppUtils: NSObject{
    
    static func showAlertMessage(message : String) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(okAction);
            topMostController().present(alertController, animated: true, completion: nil)
        }
    }
    static func topMostController() -> UIViewController {
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        
        return topVC!;
    }
    static let CITYERROr            = "city not found"
}
