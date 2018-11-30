//
//  ViewController.swift
//  UIBEnglish
//
//  Created by Aslan on 26.09.2018.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Reachability

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        guard defaults.bool(forKey: "loggedIn")==true else {
            self.performSegue(withIdentifier: "loginView", sender: self)
            return
        }
        self.performSegue(withIdentifier: "menuView", sender: self)
    }
}

