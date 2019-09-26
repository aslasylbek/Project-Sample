//
//  UserNotification.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/19/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class UserNotification{
    
    static let shared = UserNotification()
    
    
    func requestAuthorization()  {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if success {
                self.createNotification()
            }else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func createNotification()  {
        let content = UNMutableNotificationContent()
        content.title = "Wake up"
        content.sound = UNNotificationSound.default
        
        
    }
    
    
}
