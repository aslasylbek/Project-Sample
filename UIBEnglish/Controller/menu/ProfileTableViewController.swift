//
//  ProfileTableViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/22/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentGroup: UILabel!
    @IBOutlet weak var studentSpec: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var discipline: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        guard let name = defaults.string(forKey: "student_name") else {
            return
        }
        studentName.text = name
        studentGroup.text = defaults.string(forKey: "student_group")
        if let student_code = defaults.string(forKey: "student_code"){
            studentSpec.text = "\(student_code) - \(defaults.string(forKey: "student_program")!)"
        }
        else{
            studentSpec.text = defaults.string(forKey: "student_program")
        }
        teacherName.text = defaults.string(forKey: "teacher_name")
        discipline.text = defaults.string(forKey: "disc_name")
        defaults.synchronize()
    }
    @IBAction func onLogginOut(_ sender: UIButton) {
        
        guard let token = Messaging.messaging().fcmToken else {
            return
        }
        // Sending token and device id to server
        if Connectivity.isConnectedToInternet {
            sendDeviceInfoToServer(token: token)
        }
        else {
            Utils.noInternetMessage(controller: self)
        }
        
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
        showHUD("Logging out")
        let params = ["user_id": "0",
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
                    print("Ottvet",json)
                    if json["success"].int == 1{
                        self.defaults.removeObject(forKey: "student_group")
                        self.defaults.removeObject(forKey: "student_name")
                        self.defaults.removeObject(forKey: "student_code")
                        self.defaults.removeObject(forKey: "student_program")
                        self.defaults.removeObject(forKey: "teacher_name")
                        self.defaults.removeObject(forKey: "disc_name")
                        self.defaults.set("", forKey: "user_id")
                        self.defaults.set(false, forKey: "loggedIn")
                        self.defaults.synchronize()
                        
                        let splashVC = self.storyboard?.instantiateViewController(withIdentifier: "SplashVC") as! ViewController
                        
                        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        appDel.window?.rootViewController = splashVC
                    }
                    else if json["success"].int==0{
                    }
                    self.hideHUD()
                    
                }
                else{
                    print("Error cabrone")
                    self.hideHUD()
                }
        }
    }
    
    private func getConfStringFromBinary(param: Any) -> String{
        let mirror = Mirror(reflecting: param)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
}
