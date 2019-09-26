//
//  MyTabBarController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/21/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class MyTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        guard let token = Messaging.messaging().fcmToken else {
            return
        }
        
        print("New FCM ", token)
        // Sending token and device id to server
        sendDeviceInfoToServer(token: token)
        
    }
    
    private func getConfStringFromBinary(param: Any) -> String{
        let mirror = Mirror(reflecting: param)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    private func sendDeviceInfoToServer(token: String){
        
        //MARK: Get systemInformation
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let device_machine = getConfStringFromBinary(param: systemInfo.machine)
        let device_node = getConfStringFromBinary(param: systemInfo.nodename)
        let device_release = getConfStringFromBinary(param: systemInfo.release)
        let device_version = getConfStringFromBinary(param: systemInfo.version)
        let device_sysname = getConfStringFromBinary(param: systemInfo.sysname)
        
        
        
        //MARK: Make request
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        let params = ["user_id": user_id!,
                      "token": token,
                      "device_type": "ios",
                      "device_machine": device_machine,
                      "device_nodename": device_node,
                      "device_release": device_release,
                      "device_sysname": device_sysname,
                      "device_version": device_version,
                      "os_version": UIDevice.current.systemVersion] as [String : Any]
        Alamofire.request("http://de.uib.kz/mobile/tokens.php",
                          method: .post,
                          parameters: params)
            .responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Otvet", json)
                    if json["success"].int == 1{
                    }
                    else if json["success"].int==0{
                    }
                }
                else{
                    print("Error cabrone")
                }
        }
    }
}

extension MyTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
