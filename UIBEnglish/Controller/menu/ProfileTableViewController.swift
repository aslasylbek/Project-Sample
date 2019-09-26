//
//  ProfileTableViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/22/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit

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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func onLogginOut(_ sender: UIButton) {
        defaults.removeObject(forKey: "student_group")
        defaults.removeObject(forKey: "student_name")
        defaults.removeObject(forKey: "student_code")
        defaults.removeObject(forKey: "student_program")
        defaults.removeObject(forKey: "teacher_name")
        defaults.removeObject(forKey: "disc_name")
        defaults.set("", forKey: "user_id")
        defaults.set(false, forKey: "loggedIn")
        defaults.synchronize()
        
        let splashVC = self.storyboard?.instantiateViewController(withIdentifier: "SplashVC") as! ViewController
        
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDel.window?.rootViewController = splashVC
        
    }
    
}
