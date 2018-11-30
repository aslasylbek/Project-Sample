//
//  FinishViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/28/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import UICircularProgressRing

class FinishViewController: UIViewController {

    @IBOutlet weak var progressView: UICircularProgressRing!
    
    var progress: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }
    
    @IBAction func tappedButti(_ sender: Any) {
        progressView.startProgress(to: UICircularProgressRing.ProgressValue(progress!), duration: 2)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
