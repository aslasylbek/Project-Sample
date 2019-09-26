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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.startProgress(to: CGFloat(progress!), duration: 2)
    }
    
    @IBAction func tappedButti(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }


}
