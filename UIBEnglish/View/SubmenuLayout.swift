//
//  SubmenuLayout.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/26/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit

class SubmenuLayout: UICollectionViewCell {
    
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryDesc: UILabel!
    @IBOutlet weak var lockedView: DesignableView!
    
    var submenu: TaskCategory? {
        didSet{
            categoryIcon.image = UIImage(named: (submenu?.icon)!)
            categoryTitle.text = submenu?.title
            categoryDesc.text = submenu?.description
            
            let currentTime = Int(NSDate().timeIntervalSince1970)
            
            if  (submenu?.startTime)! <= currentTime && currentTime <= (submenu?.endTime)!{
                //self.isUserInteractionEnabled = true
                lockedView.isHidden = true
            }
            else if (submenu?.startTime)! == 0 && currentTime <= (submenu?.endTime)!{
                lockedView.isHidden = true
                //self.isUserInteractionEnabled = true
            }
            else if (submenu?.startTime)! == 0 && (submenu?.endTime)! == 0{
                lockedView.isHidden = true
                //self.isUserInteractionEnabled = true
            }
            else if currentTime >= (submenu?.startTime)! && (submenu?.endTime)! == 0{
                lockedView.isHidden = true
                //self.isUserInteractionEnabled = true
            }
            else{
                lockedView.isHidden = false
                //self.isUserInteractionEnabled = false
               
            }
        }
    }
    
    override func awakeFromNib() {
        
    }
    
}
