//
//  Utils.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/29/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    
    
    static func show_message(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    static func noInternetMessage(controller: UIViewController) {
        let myAlert = UIAlertController(title: "Oooops", message: "No Internet connection", preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        controller.present(myAlert, animated: true, completion: nil)
    }
    
    static func getDateFromTimeStamp(timeStamp : Int) -> String {
        
        let date = NSDate(timeIntervalSince1970: Double(timeStamp))
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
        // UnComment below to get only time
        //  dayTimePeriodFormatter.dateFormat = "hh:mm a"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }

}
