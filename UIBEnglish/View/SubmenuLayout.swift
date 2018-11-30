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
    
    var submenu: TaskCategory? {
        didSet{
            categoryIcon.image = UIImage(named: (submenu?.icon)!)
            categoryTitle.text = submenu?.title
            categoryDesc.text = submenu?.description
        }
    }
}
